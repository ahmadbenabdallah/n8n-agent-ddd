# Transaction status semantics

`created` = transaction/order record created according to adapter semantics.

`authorized` = payment authorization obtained; capture may still be pending.

`captured` = payment captured according to adapter/PSP.

WF-15 maps these to sanitized states:
- created
- authorized
- paid

Do not equate `authorized` with `captured` unless the commerce/PSP contract explicitly guarantees immediate capture.
