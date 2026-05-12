---
type: Directive
subtype: Profile Model Creation

title: ICOS Profile Model Creation Directive
document_id: SW-ICOS-DIR-2026-0027

classification: Internal
authority_level: Executive
department: "02 - Operations"
office: "Software Direction / Native Runtime & Model Sovereignty"
owner: "Founder / CEO (Public: ARTAN)"

stakeholders:
  - "Founder / CEO (Public: ARTAN)"
  - "Operations"
  - "Infrastructure"
  - "AI Runtime Infrastructure"
  - "Software Agents"
  - "Legal Operations"

legal_sensitive: true
requires_gc_review: true
requires_creo_review: true
approval_status: Draft

gsa_protocol: "Pending Executive Validation"
gsa_approved: false

status: Active
lifecycle: Draft
system: "GSA-Governed"

spine_version: "1.4"
template_lock: "Global-Metadata-Standard-v1.6"
version: "2.0"

created_date: "2026-04-28"
last_updated: "2026-04-28"
last_reviewed: "2026-04-28"
review_cycle: "Continuous"

effective_date: "2026-04-28"

publish: false
publish_to_website: false
featured: false
visibility: Internal
institutional_visibility: Executive

scope:
  - "Profile-Based Model Creation"
  - "Voice & Thought Training"
  - "Source Ingestion & Provenance"
  - "Permissioned Training"
  - "Model Readiness & Reliability"

index_targets:
  - "Software Direction Master Index"

vault_path: "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/06 - Profile Model Creation/01 - Profile Model Creation Directive.md"

related:
  - "software/macos/08 - Software Direction/05 - Workspace & File System Architecture/05 - Agent Native File Awareness Model/01 - Agent Native File Awareness Model.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/05 - Model Adoption & Import/01 - Model Adoption & Import Protocol.md"
  - "software/macos/08 - Software Direction/06 - Native Runtime & Model Sovereignty/04 - Local Model API Gateway/01 - Local Model API Gateway Standard.md"

 tags:
  - "icos"
  - "profile"
  - "model-creation"
  - "voice"
  - "software-direction"
---

## PURPOSE

Define how user profiles are transformed into ICOS models through governed, permissioned training and structured data ingestion.

---

## CORE POSITION

Profile is the model.

Model creation is a governed transformation of profile data into executable intelligence.

---

## PROFILE AS SOURCE

Profile must aggregate:

- explicit user inputs
- reflection history
- voice samples
- linked sources (documents, accounts)

Profile is the canonical training surface.

---

## PROFILE STRUCTURE MODEL

Profile must be structured into layers:

- core identity (user-defined)
- source corpus (documents, links)
- interaction history (sessions)
- voice layer (audio/text)

Each layer must be independently addressable and versioned.

---
---

## TRAINING INPUT TYPES

Supported inputs:

- text (notes, documents)
- voice (recordings, transcripts)
- structured sources (linked accounts)
- interaction logs (sessions)

All inputs must be tagged with provenance.

---

## INPUT NORMALIZATION

All inputs must be normalized to:

- canonical text representation
- timestamped entries
- provenance-linked records

No raw or unstructured input may enter training.

---
---

## PERMISSION MODEL

Each input must define:

- training permission
- public display permission
- verification permission

Permissions are independent and revocable.

---

## INGESTION PIPELINE

1. intake
2. permission validation
3. normalization
4. weighting
5. indexing
6. training integration

No direct ingestion into runtime.

---

## PIPELINE ATOMICITY

Each ingestion step must be:

- atomic
- reversible
- logged

Partial ingestion states are not allowed.

---
---

## WEIGHTING & SIGNALS

System must compute:

- recency
- frequency
- source trust
- user-confirmed importance

Weights influence model behavior.

---

## SIGNAL STORAGE

Computed signals must be stored as:

- explicit metadata
- versioned attributes
- queryable features

Signals must be accessible to runtime and evaluation systems.

---
---

## VOICE TRAINING

Voice layer must:

- process audio → text → embeddings
- capture tone, cadence, phrasing
- map to response shaping rules

Voice is identity infrastructure, not UI styling.

---

## MODEL BUILD

Model instance must bind:

- base LLM (local runtime)
- profile embeddings
- voice shaping layer
- permission filters

Result = profile-specific ICOS model.

---

## MODEL COMPOSITION

Model must be composed of:

- base LLM runtime
- embedding index (profile data)
- retrieval layer
- response shaping layer (voice + tone)

Composition must remain modular.

---
---

## READINESS STATES

Expose:

- voice readiness
- source depth
- pattern depth
- reliability level

States must be computed and visible.

---

## READINESS COMPUTATION

Readiness must be computed from:

- data volume
- signal consistency
- coverage breadth
- validation outcomes

Computation must be deterministic.

---
---

## RELIABILITY

System must evaluate:

- consistency of outputs
- alignment with sources
- coverage gaps

Reliability gates public interaction.

---

## RELIABILITY METRICS

System must track:

- response consistency score
- source alignment score
- uncertainty indicators

Metrics must be visible and logged.

---
---

## PUBLIC / PRIVATE STATES

Model states are independent:

- private (default)
- public (non-searchable)
- public (searchable)
- interactable (permissioned)
- legacy-enabled

No default exposure.

---

## STATE TRANSITION RULES

State changes must:

- require explicit user action
- be logged and reversible
- trigger re-evaluation of permissions

No implicit transitions allowed.

---
---

## LEGACY CONTINUITY

Requires explicit authorization:

- scope of interaction
- data exposure limits
- revocation path

---

## LEGACY EXECUTION CONSTRAINTS

Legacy interaction must:

- be bounded by authorized scope
- restrict access to sensitive data
- expose limitation signals to users

---
---

## ABUSE & SAFETY

Enforce:

- impersonation resistance
- consent verification
- misuse prevention

Training must be explainable and reversible.

---

## AGENT INTEGRATION

Agents must:

- use only registered profile models
- respect permissions at runtime
- surface readiness and limits

---

## AGENT–PROFILE CONTRACT

Agents must:

- access profile via governed APIs
- never bypass permission checks
- respect model state and readiness

---

## NO SHORTCUT RULE

No model may be created without:

- permissioned inputs
- normalization
- indexing
- readiness evaluation

---

## TRACEABILITY

Each profile-to-model transformation must record:

- input sources
- applied weights
- pipeline stages
- readiness outputs

Trace must be auditable.

---
---

## FAILURE CONDITION

Model is created from unverified or non-permissioned data, or exposes identity without controls.

---

## SUCCESS CONDITION

Profile transforms into a governed, permissioned, reliable ICOS model with explicit readiness and controlled exposure.

---

## Change Log

- 2026-04-28 — v2.0 Profile model creation directive defined with governed ingestion, permissioned training, and readiness exposure. Operator Name: Artan. Operator Personnel ID: CEO-001-01-01. Agent Name: Website Systems & Development Agent. Agent ID: A-0205-0022. Execution Date: 2026-04-28. Execution Context: Profile-to-model pipeline definition.
- 2026-04-28 — v1.0 Initial document created.

---

## Document Control & Validation

GSA PROTOCOL STATUS: Pending Executive Validation  
GSA APPROVAL: false  
DOCUMENT STATUS: Active — Draft  
VISIBILITY: Internal  
PUBLISH TO WEBSITE: No  
VERSION: 2.0

---

END OF DOCUMENT