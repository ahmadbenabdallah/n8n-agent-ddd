# Workflow Drift Detection

Production n8n workflows should be version-controlled.

Detect:
- workflow changed outside approved deployment;
- missing/extra nodes;
- unexpected connection changes;
- credential references changed;
- environment configuration drift;
- prompt/model version drift;
- webhook changes;
- disabled critical workflow;
- schedule changes;
- unexpected active/inactive state.

Recommended controls:
- export workflow definitions;
- hash approved production versions;
- compare deployed definitions against approved manifests;
- alert on drift;
- require change-control record.

Drift detection reports; it does not silently overwrite production.
