# Motion design de engenharia

Versão: 1.0.0
Status: Estável
Categoria: Operacional
Aplicabilidade: Condicional para projetos que planejam, implementam ou avaliam movimento em uma experiência visual.
Derivado de: LF Engineering Framework 1.3.0; manutenção pós-tag

---

## Objetivo

Definir uma forma independente de tecnologia para planejar, implementar e
validar movimento como parte de uma interface ou experiência visual. O movimento
deve comunicar intenção, apoiar a interação e permanecer acessível, útil e
performático.

Este módulo complementa `ENGINEERING_DESIGN_PERFORMANCE`. Ele não adiciona uma
fase ao workflow nem exige animação em projetos que não precisam dela.

---

## Consumidores

Principais:

- Product Owner Agent
- Design System Analyst Agent
- Software Architect Agent
- Sprint Planner Agent
- QA-Security Agent
- Tech Lead Agent

De apoio, quando houver movimento no escopo:

- Implementation / selected CLI
- Code Reviewer Agent
- Documentation Agent
- Engineering Knowledge Extractor Agent

---

## Dependências

Obrigatórias:

- `ENGINEERING_FOUNDATIONS`
- `ENGINEERING_WORKFLOW`
- `ENGINEERING_QUALITY`

Relacionadas:

- `ENGINEERING_DESIGN_PERFORMANCE`
- `ENGINEERING_ARTIFACTS`
- `ENGINEERING_STANDARDS`
- `ENGINEERING_TEMPLATES`

---

## Aplicabilidade e limites

Use este módulo quando um produto utilizar intencionalmente animações,
transições, microinterações, movimento vinculado à rolagem ou assets 2D/3D
animados. Se o movimento não fizer parte do escopo do produto, registre-o como
não aplicável em vez de adicionar movimento decorativo ou trabalho de validação.

O contrato de movimento pode ficar em `docs/DESIGN.md` quando esse artefato
existir. Se ele for dispensado, registre os resultados visíveis ao usuário e os
critérios de aceite em `docs/PRD.md`, e as restrições relevantes de implementação
em `docs/ARCHITECTURE.md`.

O Framework não prescreve estilo visual, biblioteca de movimento, framework
frontend, valor fixo de duração nem meta universal de taxa de quadros.

---

## Contrato de motion design

Antes da implementação, registre as decisões necessárias para que o movimento
seja intencional e testável:

- **Propósito e contexto:** a ação do usuário, mudança de estado ou necessidade
  de comunicação atendida pelo movimento; identifique o público e o contexto da
  tarefa relevantes sem inventar pesquisa de usuários.
- **Hierarquia:** qual elemento lidera, como os elementos de apoio se comportam e
  se a sequência ou o movimento simultâneo preserva melhor a clareza.
- **Comportamento:** direção, distância relativa, timing, easing, repetição,
  interrupção e reversão quando relevantes. Selecione valores para o contexto do
  produto; tabelas e proporções publicadas são heurísticas, não requisitos.
- **Acessibilidade e controle:** comportamento para movimento reduzido,
  informações essenciais que devem permanecer disponíveis sem animação e
  controles para movimento contínuo ou iniciado automaticamente quando
  aplicável.
- **Comportamento responsivo:** diferenças necessárias para os viewports,
  métodos de entrada e restrições de dispositivos relevantes.
- **Evidências e responsáveis:** como o resultado será revisado, quem o aprova e
  quais decisões continuam propostas ou não verificadas.

Mantenha distintos os requisitos aprovados do produto, as referências
observadas, as interpretações derivadas e as propostas. A aprovação de uma
proposta não é evidência de preferência do usuário nem validação de usabilidade.

---

## Princípios de design

- Decida o que o movimento comunica antes de escolher propriedades ou escrever
  código de animação.
- Prefira feedback claro, orientação e comunicação de estado à decoração.
- Ajuste a intensidade e o timing à importância e à frequência da interação;
  interações repetidas devem continuar previsíveis e moderadas.
- Estabeleça uma ação primária clara e coordene elementos relacionados para que
  o movimento não concorra com o conteúdo ou outra interação ativa.
- Use sequenciamento, antecipação, continuação ou estrutura narrativa somente
  quando melhorarem a compreensão ou a expressão pretendida.
- Mantenha o estado real de conclusão da operação separado do feedback visual. A
  animação não deve indicar sucesso antes de uma ação assíncrona ser concluída.
- Trate recomendações de duração, easing, distância e quantidade de elementos
  como heurísticas dependentes do contexto. Valide o resultado na velocidade
  normal de reprodução.

---

## Acessibilidade e controle do usuário

- Respeite a configuração `prefers-reduced-motion` do usuário e ofereça uma
  experiência equivalente com movimento reduzido. Preserve conteúdo essencial,
  estado, foco e funcionalidade.
- Quando apropriado, substitua grandes movimentos espaciais, parallax, giros ou
  movimentos de mola por uma transição mais simples ou uma mudança de estado
  imediata.
- Não comunique um estado ou instrução essencial somente por movimento.
- Evite movimentos que distraiam da tarefa ou causem desconforto; avalie em
  contexto efeitos em grande escala, rápidos, piscantes ou sensíveis ao sistema
  vestibular.
- Quando aplicável, permita pausar, interromper ou controlar movimentos que
  começam automaticamente ou são contínuos.
- Não condicione ações essenciais ao hover ou à conclusão de uma animação.
  Preserve o acesso por teclado, toque e tecnologias assistivas.

---

## Performance e implementação

- Prefira `transform` e `opacity` quando atenderem à intenção de design, mas
  verifique o custo real de renderização; nenhuma das propriedades garante
  performance fluida em todos os contextos.
- Evite animações que gerem muito trabalho de layout e leituras/escritas
  repetidas de layout quando houver alternativa equivalente de menor custo.
  Meça movimentos custosos ou vinculados à rolagem em rotas e dispositivos
  representativos.
- Limpe ou cancele o trabalho de animação quando seu componente, rota ou estado
  proprietário não estiver mais ativo. Evite callbacks obsoletos e interações
  que deixem elementos em estado incorreto.
- Coordene comportamento responsivo e preferências de movimento reduzido com o
  sistema de implementação selecionado. Não envie grandes dependências de
  animação por conveniência sem avaliar seu valor e custo.
- Não prometa taxa de quadros fixa com base na escolha de uma biblioteca ou em
  uma revisão do código-fonte. Ao medir performance, registre dispositivo, rota,
  ferramenta e evidências.

---

## Ferramentas opcionais e pipelines visuais especializados

O projeto seleciona ferramentas de implementação conforme sua arquitetura e
restrições existentes. GSAP, CSS, Web Animations API e sistemas específicos de
framework são escolhas de implementação, não padrões do Framework. Quando um
projeto selecionar GSAP, use a documentação oficial atual do GSAP para detalhes
de API e ciclo de vida; não aplique padrões específicos do GSAP a outros
sistemas.

A reconstrução procedural de 3D é uma capacidade separada e opt-in. Quando um
projeto precisar explicitamente dela, use um pipeline delimitado que verifique a
adequação da referência, defina uma especificação estruturada do asset, construa
em etapas com gates, valide propriedades técnicas, revise vistas renderizadas
segundo critérios acordados e registre evidências e limitações. Métricas de
similaridade visual são sinais, não prova de correção. Não presuma
fotogrametria, reconstrução exata, prontidão para produção nem instalação de
skill, plugin ou dependência. Exija aprovação explícita do projeto antes de
instalar qualquer ferramenta externa.

---

## Validação e evidências

Quando houver movimento no escopo, revise a experiência implementada conforme o
contrato aprovado e inclua uma Revisão de movimento condicional em
`docs/PERFORMANCE_VALIDATION_REPORT.md`:

- Verifique o propósito, a hierarquia e o comportamento dos estados em jornadas
  representativas.
- Teste os comportamentos normal e de movimento reduzido, inclusive a
  preferência do sistema operacional ou navegador quando suportada.
- Verifique interação por teclado e toque, interrupção, repetição, foco e acesso
  ao conteúdo quando o movimento for ignorado ou atrasado.
- Revise separadamente cada comportamento relevante em mobile e desktop. Use
  capturas de tela para estados visuais e gravação ou evidência temporal
  equivalente quando uma imagem estática não mostrar o comportamento.
- Meça performance quando o efeito for custoso, contínuo, vinculado à rolagem ou
  identificado de outra forma como risco. Registre honestamente quando faltarem
  evidências.
- Registre achados, exceções, responsáveis e acompanhamento. Uma verificação
  estática de código ou estrutura, sozinha, não é aprovação visual.

Se não houver movimento no escopo, marque a Revisão de movimento como não
aplicável e declare a superfície inspecionada. Continue aplicando os requisitos
separados de performance e acessibilidade por rota/perfil de
`ENGINEERING_DESIGN_PERFORMANCE`.

---

## Artefatos relacionados

- `knowledge/ENGINEERING_DESIGN_PERFORMANCE.md`
- `knowledge/ENGINEERING_QUALITY.md`
- `PROJECT_TEMPLATE/docs/DESIGN.md`
- `protocols/PERFORMANCE_VALIDATION.md`
- `schemas/PERFORMANCE_VALIDATION_REPORT.schema.md`
- `PROJECT_TEMPLATE/docs/PERFORMANCE_VALIDATION_REPORT.md`

---

## Referências de origem

Os repositórios a seguir informaram esta síntese seletiva. Suas ferramentas,
etapas de instalação, heurísticas fixas e recomendações específicas de
bibliotecas não são adotadas como requisitos do Framework:

- [Motion Design Skill da LottieFiles](https://github.com/lottiefiles/motion-design-skill)
- [GSAP Skills](https://github.com/greensock/gsap-skills)
- [img2threejs](https://github.com/img2threejs/img2threejs)

---

## Histórico de versões

- `1.0.0` — 2026-11-01: Adicionadas orientações condicionais de planejamento de
  motion design, acessibilidade, neutralidade de implementação e revisão
  baseada em evidências.
