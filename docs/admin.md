
# React Admin Portal Implementation Plan

Goal: Save and publish a validated site content JSON (SushiZen template) into Firebase Firestore, with schema enforcement matching the agreed JSON shape.

## A. Firebase setup

1. Create a Firebase project in Firebase Console.
2. Create a Web App inside the Firebase project and copy the Firebase config.
3. Enable Firestore Database.
4. Optional but recommended: Enable Firebase Authentication (email/password is fine for MVP).
5. Optional if uploading images: Enable Firebase Storage.

Deliverable: Firebase project ready and config available.

---

## B. React project setup

1. Install Firebase SDK:

```bash
npm i firebase
```

2. Install schema validation library:

```bash
npm i zod
```

Optional for nicer errors:

```bash
npm i zod-validation-error
```

3. Add Firebase init file:

* Create `src/lib/firebase.ts`
* Initialize firebase app
* Export `db` (Firestore) and `auth` (if using auth) and `storage` (if using Storage)

Deliverable: React app can import `db` and write to Firestore.

---

## C. Firestore data model

Use these paths:

### Site meta

* `sites/{siteId}`
  Fields:
* `templateId`: `"sushizen"`
* `createdAt`: timestamp
* `updatedAt`: timestamp
* `domain`: optional string
* `ownerId`: optional (if using auth)

### Content docs

* `sites/{siteId}/content/draft`
  Fields:

* `data`: the JSON document

* `updatedAt`: timestamp

* `sites/{siteId}/content/published`
  Fields:

* `data`: the JSON document

* `publishedAt`: timestamp

### Version snapshots (optional but recommended)

* `sites/{siteId}/versions/{versionId}`
  Fields:
* `data`
* `publishedAt`
* `schemaVersion`
* `templateId`

Deliverable: all devs use the same Firestore paths.

---

## D. Freeze the content contract

1. Create folder: `src/templates/sushizen/`
2. Add the agreed JSON example as:

* `src/templates/sushizen/example.content.json`

3. This file is the source of truth for keys and structure.

Deliverable: contract is saved in the repo.

---

## E. Schema enforcement using Zod

### E1. Create the schema file

1. Create: `src/templates/sushizen/schema.ts`
2. Define a Zod schema that matches the JSON exactly.

Rules:

* All objects have the exact keys shown.
* All fields shown are required.
* Arrays must contain the correct object shape.
* Use `.strict()` on objects if we want to reject any unknown extra keys.

Deliverable: `SushiZenContentSchema` exists.

### E2. Create a validator helper

1. Create: `src/templates/sushizen/validate.ts`
2. Export:

* `validateSushiZenContent(input)` returns either:

  * `{ ok: true, data }`
  * `{ ok: false, issues }`

Where `issues` includes paths like `hero.cta.route`, `footer.columns[0].bodyLines[1]`.

Deliverable: Save and Publish flows can call one function to validate.

---

## F. Editor state to JSON builder

1. Ensure the editor form state can be converted into the JSON structure.
2. Create a single function:

* `buildSushiZenContent(formState): SushiZenContent`

3. It must output keys exactly as the contract JSON:

* meta
* navigation
* hero
* intro
* contentSection
* feature
* social
* notice
* footer

Deliverable: editor has one canonical conversion to JSON.

---

## G. Firestore integration in the editor

### G1. Site creation (when template is chosen)

1. Generate `siteId` (uuid recommended).
2. Write `sites/{siteId}` meta doc with templateId and timestamps.
3. Write initial draft:

* `sites/{siteId}/content/draft` with:

  * `data = example.content.json` or default content
  * `updatedAt = now`

Deliverable: selecting template creates a site and draft content.

### G2. Load draft on editor open

1. Fetch:

* `sites/{siteId}/content/draft`

2. If exists:

* Validate it using `validateSushiZenContent`
* If valid, hydrate editor state
* If invalid, show warning and list errors

3. If missing:

* create draft using default JSON

Deliverable: refresh does not lose work.

---

## H. Save Draft (schema gate)

1. Add Save Draft button.
2. On click:

* Build JSON from form state using `buildSushiZenContent`
* Validate using `validateSushiZenContent`
* If invalid:

  * do not write to Firestore
  * show error list mapped to fields
* If valid:

  * write to `sites/{siteId}/content/draft`:

    * `data`
    * `updatedAt`

Deliverable: only schema valid JSON can be saved as draft.

---

## I. Autosave (optional)

1. Watch editor state changes.
2. Debounce 800 to 1500 ms.
3. Run the same Save Draft logic, but:

* Only autosave when validation passes
* If invalid, show “not saved” state

Deliverable: draft persists without clicking Save.

---

## J. Publish (schema gate, version snapshot)

1. Add Publish button.
2. On click:

* Build JSON from editor state
* Validate using `validateSushiZenContent`
* If invalid: block publish and show errors
* If valid:

  1. Write to `sites/{siteId}/content/published`:

     * `data`
     * `publishedAt`
  2. Optional: create version snapshot:

     * `sites/{siteId}/versions/{versionId}`

Version id options:

* timestamp string
* incrementing version number stored on `sites/{siteId}`

Deliverable: published content is always schema correct and rollbackable.

---

## K. Schema drift prevention test

Goal: guarantee the schema matches the example JSON forever.

1. Add a simple unit test that:

* Imports `example.content.json`
* Runs `SushiZenContentSchema.parse(example)`
* Must pass

If no test framework:

* add a `npm run validate:sushizen-schema` script that runs a small node file to parse the JSON and exit non-zero on failure.

Deliverable: contract breaks get caught immediately.

---

## L. Optional: Image upload steps (Firebase Storage)

1. Upload image to:

* `sites/{siteId}/assets/{uuid}.jpg`

2. Get download URL.
3. Put the URL into the JSON field (example `hero.media.primaryImageUrl`).
4. Save Draft and Publish as normal.

Deliverable: editor supports uploads, JSON stores URLs only.

---

## M. Optional but recommended: secure Publish via Cloud Function

This is a later hardening step.

1. React calls `POST publish(siteId)`
2. Cloud Function reads draft, validates schema server-side, writes published.
3. React only triggers publish, it does not directly write published.

Deliverable: no one can bypass schema by writing directly to Firestore.

