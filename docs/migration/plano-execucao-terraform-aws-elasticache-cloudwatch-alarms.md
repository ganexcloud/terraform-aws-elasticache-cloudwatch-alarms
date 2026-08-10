# Plano de execucao: terraform-aws-elasticache-cloudwatch-alarms

> Revisão técnica em 2026-08-10 BRT: contrato de memória Memcached fechado como `BytesUsedForCacheItems` com threshold explícito em bytes. As baselines de `planned_values` e scanner foram geradas; ver `evidencias-fase1-terraform-aws-elasticache-cloudwatch-alarms.md`.

## 0. Reconciliacao de parametros

| Parametro | Valor declarado ou confirmado | Valor observado | Evidencia | Acao |
| --------- | ----------------------------- | --------------- | --------- | ---- |
| Origem Memcached | GitLab, `master` | SHA `09cee6d8da030f8ba5fed67cc9087b952112286b` | `rtk proxy git ls-remote --heads https://gitlab.com/ganex-cloud/terraform/terraform-aws-elasticache-memcached-cloudwatch-alarms refs/heads/master`; checkout local | Baseline A. |
| Origem Redis | GitLab, `master` | SHA `d2ffdb33a96072041c903685ec7c5f067840964a` | `rtk proxy git ls-remote --heads https://gitlab.com/ganex-cloud/terraform/terraform-aws-elasticache-redis-cloudwatch-alarms refs/heads/master`; checkout local | Baseline B. |
| Destino | `ganexcloud/terraform-aws-elasticache-cloudwatch-alarms`, público | Repositório ausente | `rtk proxy git ls-remote https://github.com/ganexcloud/terraform-aws-elasticache-cloudwatch-alarms` retornou `Repository not found` | Criar na Fase 2 com visibilidade pública. |
| Template | `terraform-aws-cloud-custodian` | SHA `ebe602117715e3d400bdbe458df16e7553cd270b` | template canônico já extraído | Reutilizar estrutura de CI, release, lint e docs. |
| Estratégia | Consolidação Ganex confirmada em 2026-08-10 BRT | Não há equivalente oficial composto por engine | análise de consolidação | `MANTER_GANEX`, com sucessor único. |
| Arquivamento GitLab | `AUTO` resolvido | Duas origens e estratégia MANTER_GANEX | política global | `APOS_PUBLICACAO_GANEX` para ambas. |

Desvio explícito da migração de uma única origem: o destino preservará os dois históricos via merge semântico de históricos não relacionados, registrando ambos os SHAs no baseline. Nenhuma origem será confundida com a baseline da outra.

## 1. Resumo da decisao

- Estratégia: consolidar Memcached e Redis em `terraform-aws-elasticache-cloudwatch-alarms`.
- Aprovação do gate: pendente.
- Visibilidade: pública, compatível com Terraform Registry.
- Política GitLab: arquivar ambas as origens somente após `v1.0.0` confirmada no Registry, clone anônimo verde e preflights administrativos aprovados.
- O módulo oficial CloudWatch foi descartado porque oferece alarmes genéricos e não o conjunto ElastiCache padronizado por engine.
- Contrato alvo: `engine` obrigatório, valores `memcached` ou `redis`; conjunto comum de alarmes mais métricas Redis exclusivas. Durante a primeira versão consolidada, aceitar os aliases legados `id` e `cache_cluster_id`, com validação para exatamente uma lista efetiva de clusters.
- Estratégia de state: preservar inicialmente os nomes internos dos recursos e o padrão `count` dos módulos legados. Com o mesmo label de `module` no consumidor, os endereços comuns permanecem idênticos. Não introduzir `for_each` nesta release, pois `moved` não pode mapear dinamicamente índices legados a IDs sem configuração específica do consumidor.
- Correções funcionais confirmadas no escopo:
  - Memcached Swap: `CPUUtilization` para `SwapUsage`.
  - Memcached Evictions: `CPUUtilization` para `Evictions`, com estatística `Sum` para representar a contagem do período. O baseline usava `Average`; a divergência entra em teste e notas de release.
  - Memcached Memory: `CPUUtilization` para `BytesUsedForCacheItems`, com estatística `Average`. Introduzir `memcached_bytes_used_for_cache_items_threshold` como número opcional sem default. Quando `engine = "memcached"` e o alarme de memória estiver habilitado, a ausência desse input falha por `precondition`. O input legado `memory_utilization_threshold` permanece declarado, marcado deprecado na documentação e sem conversão percentual implícita. Esta é mudança funcional deliberada, registrada na PR e release notes.

## 2. Constraints finais

- Terraform: `>= 1.6.0`.
- Provider AWS: `>= 5.40.0, < 7.0.0`.
- Runtime confirmado em 2026-08-10 BRT: Terraform `1.15.8`, provider AWS `6.58.0`, template com Terraform `1.15.8` e TFLint `0.58.0`.

## 3. Interface publica (baseline)

- Memcached: 29 variáveis, 0 outputs, snapshot `interface-terraform-aws-elasticache-memcached-cloudwatch-alarms-baseline.json`.
- Redis: 44 variáveis, 0 outputs, snapshot `interface-terraform-aws-elasticache-redis-cloudwatch-alarms-baseline.json` validado com `jq`.
- Novos inputs mínimos: `engine` e `memcached_bytes_used_for_cache_items_threshold`. Nenhum nome legado é removido na primeira versão consolidada; `memory_utilization_threshold` é mantido apenas para compatibilidade declarada e não define threshold em bytes.
- Fixtures: Memcached com dois IDs planeja 10 alarmes; Redis com dois IDs planeja 16. Ambas usam mock provider, sem backend e sem AWS real.
- Diferenças que precisam ser aceitas no plano da PR: novo `engine` obrigatório, correções de Swap/Evictions/Memory Memcached e possíveis preconditions para impedir configuração ambígua.
- Artefatos Fase 1: `planned-values-terraform-aws-elasticache-memcached-cloudwatch-alarms-baseline.json` contém 10 alarmes; `planned-values-terraform-aws-elasticache-redis-cloudwatch-alarms-baseline.json` contém 16. Ambos são somente `planned_values`, ordenados, e foram validados por `jq`.
- Scanner baseline: Trivy `0.73.0`, bundle `sha256:1583562f8b90ed2a071b99f0e5ffff6b57e4ceb6ca3e4796577b4e6a339eb74c`, zero findings nas duas origens. Repetir exatamente essa versão e bundle no pós; detalhes e patch da fixture em `evidencias-fase1-terraform-aws-elasticache-cloudwatch-alarms.md`.

## 4. Migracao direta ao oficial (apenas se MIGRAR_DIRETO_OFICIAL)

Não aplicável. A decisão é `MANTER_GANEX` porque o contrato de criar o conjunto de alarmes por engine não possui equivalente oficial.

## 5. Passos de execucao (comandos exatos, em ordem)

1. Registrar aprovação humana explícita deste plano, com autor, data e escopo. Criar repositório GitHub público somente depois de confirmar sua inexistência.
2. Preservar os dois históricos em clone efêmero. Criar o repositório público vazio, criar `main` a partir do Memcached, mesclar somente o histórico Redis com estratégia `ours` e registrar os dois SHAs em `MIGRATION-SOURCES.md`. Isso preserva objetos e ancestrais sem mesclar HCL legado incompatível no root:

```sh
rtk gh repo create ganexcloud/terraform-aws-elasticache-cloudwatch-alarms --public --disable-wiki
rtk git clone --origin gitlab-memcached --branch master https://gitlab.com/ganex-cloud/terraform/terraform-aws-elasticache-memcached-cloudwatch-alarms.git <checkout-destino>
rtk git -C <checkout-destino> remote add gitlab-redis https://gitlab.com/ganex-cloud/terraform/terraform-aws-elasticache-redis-cloudwatch-alarms.git
rtk git -C <checkout-destino> fetch gitlab-redis master
rtk git -C <checkout-destino> switch -c main gitlab-memcached/master
rtk git -C <checkout-destino> merge -s ours --allow-unrelated-histories gitlab-redis/master -m "chore: preserve Redis module history"
rtk git -C <checkout-destino> remote add origin https://github.com/ganexcloud/terraform-aws-elasticache-cloudwatch-alarms.git
rtk git -C <checkout-destino> push -u origin main
rtk gh repo edit ganexcloud/terraform-aws-elasticache-cloudwatch-alarms --default-branch main
```
3. Adicionar `MIGRATION-SOURCES.md` contendo URLs, branches e os dois SHAs de baseline, criar o commit de baseline consolidado, a tag anotada `v0.1.0`, release manual correspondente e branch `modernize/elasticache-alarms`. Verificar antes se tag e release existem e apontam ao mesmo commit; divergência interrompe.
4. Replicar o template canônico: `versions.tf`, `.terraform-version`, pre-commit, Semantic Release, workflows, LICENSE, CHANGELOG, CONTRIBUTING, README e exemplos.
5. Implementar módulo próprio, sem wrapper oficial, mantendo endereços de recursos legados. Usar `count` apenas nesta release de compatibilidade; documentar a migração futura para `for_each` como trabalho separado.
6. Implementar catálogo de métricas comum e Redis, aliases das duas interfaces e validações cruzadas de engine. Impedir que alarmes exclusivos Redis sejam habilitados em Memcached.
7. Implementar as três correções Memcached como mudança declarada: `SwapUsage`, `Evictions` com `Sum` e `BytesUsedForCacheItems` com `Average`. Adicionar a precondition do novo threshold em bytes. Não converter `memory_utilization_threshold` para bytes; consumidor Memcached que habilitar a métrica deve declarar `memcached_bytes_used_for_cache_items_threshold`.
8. Rodar validações, snapshots de interface e deltas de `planned_values` contra as duas baselines. Abrir PR convencional para `main`, com `!` e footer `BREAKING CHANGE:` descrevendo `engine` obrigatório e o novo threshold Memcached.
9. Antes do merge, configurar e verificar ruleset, GitHub App e check `validate`; obter confirmação humana separada de irreversibilidade do Registry. Após merge, acompanhar Semantic Release `v1.0.0`.
10. Confirmar Registry, executar preflight de clonabilidade, schedules e mirroring para ambos os GitLab; arquivar ambos somente após todas as verificações verdes. Atualizar `status.md` com uma única entrada final.

## 6. Validacao (comandos e criterio de verde)

- `rtk terraform fmt -check -recursive`, `rtk terraform init -backend=false`, `rtk terraform validate`, `rtk tflint` e `rtk pre-commit run --all-files` verdes.
- `rtk terraform test -verbose` nas fixtures Memcached e Redis, cobrindo dois clusters, métricas desabilitadas, Redis-only, falha esperada quando faltar `memcached_bytes_used_for_cache_items_threshold` e os três alarmes Memcached corrigidos.
- Antes de editar HCL, gerar os dois JSONs `planned_values` pendentes contra o mesmo stub IAM local, usando credenciais sintéticas, `-refresh=false` e `terraform show -json`; comparar o pós contra os mesmos cenários e forma serializada.
- Diff de interface: o módulo consolidado é superset dos dois snapshots, exceto pelo novo `engine` obrigatório documentado na migração.
- Diff de `planned_values`: endereços, cardinalidade, outputs e argumentos conhecidos preservados; divergências dos três alarmes corrigidos devem coincidir exatamente com a decisão aprovada e as release notes.
- Plan contra fixtures sem destroy ou replace de recursos stateful. Para alarmes, confirmar manutenção de endereço e ausência de delete/add inesperado.
- Scanner com a mesma ferramenta, versão e políticas em baseline e pós; nenhum finding novo.
- GitHub: visibilidade pública, `main` protegido, App instalada, baseline e release validadas. Registry deve conter `v1.0.0` antes de arquivamento.
- GitLab: perfil `ganex-support-admin`, schedules vazios, pull mirroring ausente, clone anônimo de cada origem verde e `archived=true` nos dois projetos.

## 7. Definition of Done

- [ ] Dois históricos preservados e fontes/SHAs documentados no baseline consolidado.
- [x] Dois `planned_values` baseline gerados em fixture offline, prontos para o delta pós-mudança.
- [x] Trivy `0.73.0` executado nas duas baselines, com versão e bundle registrados.
- [ ] Template canônico e constraints aplicados.
- [ ] União compatível das interfaces Memcached e Redis, com `engine` e aliases documentados.
- [ ] Catálogo de métricas impede combinações incompatíveis por engine.
- [ ] Correções Memcached implementadas, incluindo precondition do threshold de `BytesUsedForCacheItems`, testadas e declaradas nas release notes.
- [ ] Deltas de interface, comportamento, scanner e state verdes ou explicitamente aprovados.
- [ ] PR, ruleset, App, baseline, release automática e Registry confirmados.
- [ ] Dois GitLab arquivados somente após preflights e Registry.
- [ ] Gate de plano e confirmação de irreversibilidade registrados separadamente.
- [ ] `status.md` atualizado uma única vez ao final.

## 8. Rollback

- Antes do Registry: remover branch, tag ou GitHub Release e restaurar as duas origens GitLab, se necessário.
- Após arquivamento: `POST /projects/:id/unarchive` para cada origem, sob nova aprovação.
- Sem rollback: publicação no Terraform Registry.
- Para consumidor: preservar o source anterior até validar plan do sucessor; reversão posterior requer source anterior e plano revisado. Nenhum `terraform state rm` é permitido.
