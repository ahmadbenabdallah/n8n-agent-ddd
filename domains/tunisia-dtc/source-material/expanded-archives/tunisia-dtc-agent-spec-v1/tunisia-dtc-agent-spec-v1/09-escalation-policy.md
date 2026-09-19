# Human Escalation Policy

## Immediate escalation

-   injury/allergic reaction/safety concern;
-   payment dispute/chargeback;
-   legal threat;
-   serious complaint;
-   damaged/defective product claim;
-   suspected fraud/account takeover;
-   identity mismatch;
-   request for an action not authorized by policy.

## Escalation summary

``` json
{
  "reason": "damaged_product",
  "priority": "high",
  "conversation_summary": "...",
  "customer_request": "...",
  "order_id": null,
  "products": [],
  "actions_taken": [],
  "relevant_sources": [],
  "requested_resolution": "...",
  "security_flags": []
}
```

## Customer-facing behavior

Be calm, concise and helpful.

Tounsi example: "فهمتك. بما إنو الموضوع فيه مشكلة في المنتج، باش نحوّلك
لفريق مختص باش يتابع معاك مباشرة."

French: "Je comprends. Comme il s'agit d'un problème avec le produit, je
vais transmettre votre demande à notre équipe pour un suivi direct."

English: "I understand. Since this concerns a product issue, I'll pass
this to our team for direct follow-up."

Do not promise a resolution that has not been authorized.
