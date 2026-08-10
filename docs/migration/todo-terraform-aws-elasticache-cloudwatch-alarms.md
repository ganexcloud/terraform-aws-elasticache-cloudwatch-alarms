# TODO: terraform-aws-elasticache-cloudwatch-alarms

- [x] Aprovar o plano de consolidação e registrar gate.
- [x] Serializar snapshot completo da interface Redis.
- [x] Gerar `planned_values` offline das duas baselines.
- [x] Disponibilizar Trivy e registrar baseline de findings.
- [x] Definir contrato de memória Memcached: `BytesUsedForCacheItems` com threshold explícito em bytes.
- [x] Criar destino e baseline com os dois históricos preservados.
- [x] Implementar contrato por engine e aliases legados.
- [x] Implementar e testar correções Memcached.
- [x] Validar os dois deltas de interface e comportamento.
- [ ] Abrir PR, configurar proteção e validar release (aguarda o gate separado de publicação/merge).
- [ ] Confirmar Registry, arquivar duas origens e atualizar status.
