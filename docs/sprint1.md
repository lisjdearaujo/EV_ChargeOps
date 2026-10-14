# EV ChargeOps — Enterprise Challenge 2026

**Parceiro:** GoodWe / FIAP Energy Innovation Lab

---

## Equipe

| Nome | RM |
|------|----|
| Eduardo Alves da Silva | RM 568601 |
| Gabrielly Drosda da Silva | RM 571793 |
| Lisandra Jacinto de Araujo | RM 574055 |
| Nathan Caio da Silva | RM 568750 |

---

## Descrição do Problema e Contexto do Desafio

A GoodWe é uma das maiores fabricantes globais de inversores e sistemas de armazenamento de energia, com presença em mais de 100 países e capacidade instalada acumulada superior a 100 GW (GoodWe, 2024). No Brasil, a empresa mantém parceria com a FIAP por meio do Energy Innovation Lab, localizado na Unidade Aclimação, onde o carregador de veículos elétricos modelo HCA G2, instalado no estacionamento L1, serve como objeto de estudo direto deste projeto.

O crescimento acelerado da frota de veículos elétricos no país evidencia um problema operacional que ainda não foi adequadamente resolvido. Infraestruturas de recarga compartilhada em condomínios residenciais, edifícios corporativos e campus universitários não dispõem de mecanismos integrados para estruturar sessões por usuário, calcular consumo individual, aplicar regras de rateio justas e oferecer uma experiência digital clara para moradores e gestores.

Cada sessão de recarga produz um conjunto de dados com potencial operacional significativo, incluindo duração, volume de energia entregue em kWh, horário de uso, frequência de acesso, picos de demanda e intervalos de ociosidade. Quando organizados e processados, esses dados deixam de ser registros isolados e passam a sustentar decisões de gestão, previsão de demanda, detecção de uso irregular e geração automática de cobranças individuais. O EV ChargeOps propõe exatamente essa transformação, utilizando inteligência artificial como motor lógico da solução.

A pergunta central que orienta o projeto é como transformar sessões de recarga de veículos elétricos em uma infraestrutura compartilhada em dados estruturados, rateio justo e inteligência acionável.

---

## Frente 1 — Contexto e Problema

Infraestrutura de recarga compartilhada é um modelo em que um ou mais carregadores são instalados em áreas comuns de um condomínio, como garagens coletivas, e ficam disponíveis para uso de vários condôminos que possuem veículos elétricos. Em vez de cada morador ter um carregador individual, o compartilhamento permite otimizar espaço e recursos.

No entanto, como toda inovação, essa traz consigo alguns desafios. O primeiro e mais crítico diz respeito à falta de uma infraestrutura elétrica adequada em prédios, trazendo à tona questões de segurança, custos operacionais e atualização do regimento interno. De fato, há um aumento da demanda por carregadores, mas pouco se vê planejamento técnico, gestão preventiva e adequação das normas internas. Além disso, os síndicos passam a avaliar com maior cautela o risco de responsabilização civil ou criminal caso autorizem instalações que futuramente se revelem inadequadas. Moradores, por sua vez, manifestam preocupação com a sobrecarga da infraestrutura elétrica e com os efeitos de instalações individuais sobre a segurança da edificação. E então, decisões que exigem conhecimento técnico especializado acabam recaindo sobre pessoas que, em regra, não possuem formação para avaliar riscos elétricos.

A isso se soma um problema igualmente relevante na dimensão financeira. Antes mesmo de qualquer orçamento, é preciso definir como os custos de instalação serão divididos e como será feita a cobrança pelo uso do carregador, e para uso coletivo essa definição depende de plataformas de gerenciamento capazes de monitorar o consumo individual de cada morador. Sem essa medição, o rateio se torna impreciso e fonte de conflito. Vale destacar ainda que o condomínio não pode lucrar com a prestação desse serviço, a cobrança deve se limitar ao valor estipulado pela concessionária e, quando aplicável, à taxa da empresa responsável pelo ponto de recarga, o que torna a transparência no controle de consumo não apenas uma conveniência, mas uma exigência.

Entender por que essa transparência é difícil de alcançar exige olhar para o que acontece dentro de uma sessão de recarga. Todo esse processo é mediado por um protocolo de comunicação chamado OCPP, sigla para Open Charge Point Protocol. Trata-se de um padrão aberto que regula a troca de informações entre as estações de recarga e os sistemas de gerenciamento centralizados, e que se tornou referência global justamente por garantir interoperabilidade entre diferentes marcas de carregadores e plataformas de gestão, sem depender de soluções proprietárias.

O ciclo de uma sessão segue etapas bem definidas. Ao ser ligado, o carregador se apresenta ao sistema central por meio de uma mensagem chamada BootNotification, informando suas capacidades e versão de firmware. A partir daí, o usuário precisa ser validado, seja por cartão RFID, aplicativo ou outro meio de autenticação. Com a autenticação confirmada, a sessão tem início e o sistema passa a registrar continuamente os valores de consumo de energia em intervalos regulares, até que o veículo seja desconectado e a sessão encerrada com o total consumido consolidado.

É nesse fluxo que os dados mais relevantes para a gestão emergem. Cada sessão produz informações sobre o status do carregador ao longo do tempo, o consumo exato em kWh, os horários de início e fim, as regras de acesso aplicadas e os eventos de falha, quando ocorrem. Com esses dados trafegando entre o carregador e um servidor externo via OCPP, torna-se possível o monitoramento em tempo real, o controle remoto das sessões, a aplicação de tarifas diferenciadas por horário ou perfil de usuário e a integração com gateways de pagamento para automação do faturamento. É essa capacidade de captura que transforma o carregador de um simples equipamento elétrico em um ponto de coleta de inteligência operacional e que, por sua vez, abre espaço para que modelos de cobrança mais justos e precisos se tornem viáveis.

Quando o assunto é como estruturar essa cobrança, o mercado já apresenta alguns caminhos consolidados. O modelo mais direto é a cobrança por kWh consumido, em que cada usuário paga exatamente pela energia que utilizou, sem divisão proporcional ou estimativas. Uma variação desse modelo é a assinatura mensal fixa combinada com o reembolso do consumo real, em que um valor fixo cobre a infraestrutura e o suporte, e o restante é cobrado conforme o uso efetivo de cada sessão.

Há ainda modelos em que o condomínio deixa de ser o gestor da operação. Empresas especializadas instalam o carregador, monitoram o uso por aplicativo e cobram diretamente de cada usuário, retirando do síndico a responsabilidade pela cobrança e pela gestão do consumo. Uma variação dessa abordagem é a locação do equipamento, em que o condomínio paga uma mensalidade fixa que já inclui manutenção e gestão, sem precisar adquirir o hardware. Empresas como a Tupinambá operam nesse formato, planejando e implementando a rede de recarga enquanto o usuário paga uma assinatura mensal proporcional ao tamanho da rede contratada, com acesso a software de gestão e a uma malha de mais de 1.400 carregadores distribuídos pelo Brasil.

O que todos esses modelos têm em comum é a dependência de um sistema capaz de medir com precisão o consumo individual, o mesmo problema apontado lá no início como ausente na maior parte das infraestruturas compartilhadas hoje. Sem essa camada, qualquer modelo de cobrança se torna impreciso ou injusto. É justamente aí que plataformas como o EV ChargeOps se tornam estruturais, atuando como uma base que viabiliza qualquer um desses modelos de negócio em uma infraestrutura compartilhada.


### Aprofundamento (C) — Análise de dados públicos

A expansão de veículos elétricos no Brasil cresceu exponencialmente nos últimos anos, por mais que o Brasil teve acesso aos carros elétricos de modo "atrasado", em 2018 chegou ao consumidor final o Renault Zoe. A partir de 2020, finalmente foi possível realizar uma análise de dados concreta, resultando em registros confiáveis para realizar o acompanhamento de sua evolução, que cresceu de forma expressiva, tendo como marco 177.358 unidades emplacadas acumuladas até 2024, número que logo foi superado: no final de 2025, o total chegou a aproximadamente 613.389 unidades, lideradas pela BYD, Toyota e GWM.

As tabelas abaixo mostram a evolução dos emplacamentos de veículos elétricos a bateria (BEV) e híbridos plug-in (PHEV) no Brasil e no estado de São Paulo. Os valores de 2026 são parciais e podem ser atualizados com o decorrer do ano.

**Emplacamentos BEV — Brasil**

| Ano  | Emplacamentos |
|------|---------------|
| 2022 | 8.457         |
| 2023 | 19.310        |
| 2024 | 61.615        |
| 2025 | 80.184        |
| 2026 | 69.488        |

**Emplacamentos PHEV — Brasil**

| Ano  | Emplacamentos |
|------|---------------|
| 2022 | 11.503        |
| 2023 | 33.049        |
| 2024 | 64.010        |
| 2025 | 99.996        |
| 2026 | 58.194        |

**Emplacamentos BEV — Estado de São Paulo**

| Ano  | Emplacamentos |
|------|---------------|
| 2022 | 2.718         |
| 2023 | 5.920         |
| 2024 | 15.913        |
| 2025 | 17.411        |
| 2026 | 14.203        |

**Emplacamentos PHEV — Estado de São Paulo**

| Ano  | Emplacamentos |
|------|---------------|
| 2022 | 4.279         |
| 2023 | 12.525        |
| 2024 | 22.576        |
| 2025 | 32.633        |
| 2026 | 18.588        |

Entretanto, há uma questão a ser resolvida. Em meio a tanto crescimento, há poucos pontos de recarga. Os dados mais recentes apontam 25.429 eletropostos públicos e semipúblicos no Brasil, um crescimento de cerca de 5.900% desde 2021, mas a proporção atual ainda é de um carregador para cada 19,6 veículos. O índice considerado adequado pelo setor é de 1 para 10, evidenciando que a infraestrutura, apesar de crescer, não acompanha o ritmo da frota.

**Eletropostos no Brasil**

| Ano  | Pontos de recarga |
|------|-------------------|
| 2021 | 800               |
| 2022 | 2.862             |
| 2023 | 4.300             |
| 2024 | 12.137            |
| 2025 | 16.880            |
| 2026 | 25.429            |

**Eletropostos em São Paulo (dados atuais)**

| Tipo                | Quantidade |
|---------------------|------------|
| AC — Recarga Lenta  | 5.401      |
| DC — Recarga Rápida | 1.553      |
| Total               | 6.954      |

A recarga em ambientes privados, como os condomínios, é considerada o cenário de maior demanda reprimida. O número de licenciamentos acumulados de veículos elétricos passou de 1,9 mil em 2020 para mais de 215 mil em 2024, um aumento de 100 vezes em cinco anos, e o ponto de recarga tem sido um dos fatores de decisão na hora de alugar ou comprar um imóvel. Com o crescimento acelerado do uso de veículos elétricos, o volume de ações judiciais por moradores de condomínios aumentou nos últimos dois anos por conta do custo de instalação, prioridade de vagas e responsabilidade civil por fiação inadequada. A ausência de uma legislação federal clara agrava o cenário: o projeto de lei nº 158/2025, que garantia ao morador o direito de instalar carregador na própria vaga com custos individuais, ainda está em período de aprovação.

Em São Paulo, a Lei 18.403/26 já está em vigor, mas ainda depende de regulamentação técnica complementar para ser aplicada com a devida segurança para os usuários. As projeções reforçam a urgência do problema: a estimativa é de aproximadamente 580 mil carregadores no Brasil até 2030, sendo 490 mil em ambientes residenciais e de frotas, um investimento estimado em R$ 6,8 bilhões que ainda necessita de soluções de gestão eficientes.

Em relação ao perfil de uso, observa-se que a maior parte dos proprietários de veículos elétricos no Brasil realiza o abastecimento em locais privados, como residências, condomínios e empresas. Mais de um terço dos proprietários considera a atual infraestrutura insuficiente, e uma parcela semelhante aponta a preocupação com a recarga como fonte de estresse. Mesmo com a predominância do uso privado, a ausência de pontos públicos acessíveis impacta diretamente a experiência do usuário.

Os dados analisados mostram um mercado em expansão acelerada com infraestrutura atrasada em relação ao nível de adoção da tecnologia, especialmente no contexto de recargas compartilhadas em ambientes de condomínios e corporativos. Esse descompasso entre a oferta de pontos de recarga e o crescimento da frota é o problema central que o projeto se propõe a resolver, oferecendo uma solução de gestão inteligente para espaços onde o compartilhamento de uso torna a demanda cada vez mais difícil de suprir sem uma plataforma dedicada.

---

## Frente 2 — Base Regulatória e Técnica

### Resolução Normativa ANEEL nº 1.000/2021

A Resolução Normativa ANEEL nº 1.000/2021 é o principal marco regulatório que governa a operação de estações de recarga de veículos elétricos no Brasil. Para o EV ChargeOps, quatro artigos são diretamente relevantes.

O artigo 554 permite que a recarga seja oferecida como serviço comercial a terceiros, com preços livremente negociados entre o operador e o usuário, sem necessidade de aprovação tarifária da ANEEL. Isso significa que um condomínio pode disponibilizar carregadores para moradores e visitantes e estabelecer seus próprios critérios de cobrança, o que é exatamente o modelo que a plataforma viabiliza.

O artigo 550 determina que a instalação de uma estação de recarga deve ser comunicada previamente à distribuidora local nos casos de nova conexão, aumento ou redução de carga ou alteração do nível de tensão. Essa comunicação existe porque carregadores, especialmente os de maior potência, representam carga significativa para a rede elétrica, e a distribuidora precisa avaliar se a infraestrutura local suporta a nova demanda, se há necessidade de reforço, se o sistema de medição precisa ser adaptado e se será necessário alterar a modalidade de fornecimento. No caso do GW7K-HCA-20, com potência de 7 kW, essa avaliação é obrigatória antes da instalação.

O artigo 552 é o mais relevante para as decisões técnicas da plataforma. Ele determina que equipamentos de recarga que não sejam de uso exclusivamente privado devem ser compatíveis com protocolos abertos de domínio público para comunicação, supervisão e controle remotos. A resolução não cita tecnologias específicas, mas os protocolos mais adotados no mercado para esse fim são o OCPP para comunicação entre carregadores e sistemas centrais, o OCPI para integração entre operadores de recarga e o OpenADR para gerenciamento energético. Essa exigência é o que justifica a adoção do OCPP como protocolo de gestão de sessões na arquitetura do EV ChargeOps: além de ser o padrão de mercado, seu uso é uma obrigação regulatória para o cenário de recarga compartilhada.

O artigo 553 complementa ao exigir que a unidade consumidora observe as normas e padrões da distribuidora local, o que pode incluir apresentação de projetos elétricos, estudos de demanda e especificações de proteção elétrica. O artigo 555 proíbe a injeção de energia dos veículos na rede pública para geração de créditos, embora permita o uso da energia do veículo para alimentar a própria instalação. Por fim, o artigo 556 reconhece veículos elétricos como passíveis de ressarcimento em casos de danos elétricos causados por problemas no fornecimento.

### Carregador GoodWe HCA G2

O carregador GoodWe HCA G2, modelo GW7K-HCA-20, é um carregador CA monofásico com potência nominal de 7 kW, instalado no estacionamento L1 da FIAP. Ele possui cinco interfaces de comunicação e conectividade, cada uma com um papel distinto na plataforma.

A interface RS-485 é um padrão de comunicação serial que utiliza sinalização diferencial, transmitindo dados pela diferença de tensão entre dois fios em vez de medir cada fio em relação ao terra. Essa característica torna a comunicação muito mais resistente a ruídos elétricos, o que é especialmente relevante em ambientes com motores, inversores de frequência e outros equipamentos elétricos como estacionamentos. O RS-485 suporta múltiplos dispositivos no mesmo barramento, opera em distâncias de até 1.200 metros e é amplamente utilizado em automação industrial e medição de energia. No carregador, o RS-485 está disponível em duas portas e serve como canal de comunicação de baixo nível para leitura de registros via Modbus RTU, sendo útil em ambientes sem infraestrutura de rede IP ou como redundância à LAN.

A interface LAN é a porta Ethernet física do equipamento, o conector RJ-45 que permite conectar o carregador à rede local cabeada. Ela é a interface de comunicação de maior estabilidade e largura de banda disponível no HCA G2, recomendada como conexão primária ao servidor da plataforma quando há infraestrutura de rede disponível no estacionamento. Pela LAN, o carregador se comunica via Modbus TCP, o protocolo nativo confirmado no datasheet oficial do equipamento.

A interface Wi-Fi permite conectar o carregador à rede local sem a necessidade de cabeamento dedicado, o que a torna a alternativa mais prática para instalações em estacionamentos de condomínios onde passar cabo não é viável. Em termos de protocolo, o Wi-Fi no HCA G2 serve o mesmo papel da LAN: comunicação com o servidor via Modbus TCP e acesso ao aplicativo SEMS+ para gestão e monitoramento.

O Bluetooth não é uma interface direta do hardware do carregador, mas está presente no aplicativo SEMS+ para pareamento e configuração inicial do equipamento. Ele não é utilizado para transmissão de dados de sessão ou comunicação com o servidor da plataforma.

A interface RFID é o sistema de identificação por radiofrequência que permite autenticar usuários sem contato físico e sem necessidade de smartphone. O leitor RFID do carregador identifica o cartão ou tag do usuário em milissegundos, valida a identidade no sistema e autoriza o início da sessão. O kit de instalação do GW7K-HCA-20 acompanha dois cartões RFID. Essa interface é relevante especialmente para usuários que preferem não depender de aplicativo ou para cenários onde o acesso ao smartphone não é conveniente, como em estacionamentos com baixo sinal de celular.

### API GoodWe — SEMS Portal

A plataforma SEMS+ da GoodWe expõe dados do carregador organizados em cinco seções, todas acessadas pela equipe diretamente na plataforma durante a pesquisa.

Os registros de carregamento contêm os dados mais críticos para o modelo de rateio: data e hora de início e de término de cada sessão, energia total carregada em kWh, energia verde carregada em kWh, potência média e potência máxima do carregador em kW, razão do término da recarga, identificador do carregador, porta utilizada e flag de veículo conectado. Esses campos são a fonte primária para o cálculo de consumo individual por sessão e para o treinamento dos modelos de IA descritos na Frente 3.

O monitoramento de operação retorna leituras de potência em kW espaçadas a cada 10 minutos ao longo do dia. Essa granularidade é suficiente para identificar padrões de uso horário e alimentar o modelo de previsão de demanda, embora seja menos precisa que os MeterValues do OCPP, que operam a cada 60 segundos.

O monitoramento de recarga detalha, também em intervalos de 10 minutos, os tipos de energia utilizados em cada momento: energia verde, energia da rede e energia carregada, com os respectivos valores em kWh. Esse dado é relevante para cenários em que o condomínio opera com geração solar, como é o caso do Energy Innovation Lab da FIAP.

Os registros de controle documentam os comandos operacionais enviados ao carregador, incluindo o item controlado, como potência mínima, modo de recarga e potência máxima, o valor configurado, o resultado do comando, o canal de origem, como web ou aplicativo, e o operador responsável. Esses registros permitem auditar alterações de configuração e identificar mudanças que possam ter impactado o comportamento do equipamento em determinado período.

A seção de alarmes expõe os eventos de falha do equipamento com nome do alarme, nível de severidade, status de recuperação, componente afetado, duração e tempo de recuperação. Esses dados são a fonte para o módulo de detecção de anomalias da plataforma, complementando os dados de sessão na identificação de comportamentos atípicos causados por falha do equipamento.

### Aprofundamento (B) — Exploração da API GoodWe

O mapeamento da API SEMS+ foi realizado com acesso direto à plataforma, documentando os campos disponíveis em cada seção conforme descrito acima. A API expõe histórico de sessões individuais com timestamps de início e fim, kWh por sessão e potência média e máxima, o que confirma que os dados necessários para alimentar os modelos de IA da Frente 3 estão disponíveis sem necessidade de integração com fontes externas para os campos essenciais de consumo.

---

## Frente 3 — Arquitetura e IA

A plataforma EV ChargeOps é organizada em quatro camadas interdependentes. Cada camada tem uma responsabilidade clara e se comunica com a camada adjacente de forma estruturada. Entender essa separação é o que torna possível raciocinar sobre o fluxo de dados completo, desde o momento em que o veículo é conectado até a geração da fatura ao final do mês.

A primeira camada é a física, representada pelo carregador GoodWe HCA G2, modelo GW7K-HCA-20, instalado no estacionamento L1 da FIAP. Trata-se de um carregador CA monofásico com potência nominal de 7 kW, tensão de entrada de 220 V e corrente de 32 A. Ele opera por convecção natural, tem grau de proteção IP66, o que significa que pode ser instalado em ambientes expostos como estacionamentos cobertos ou abertos, e suporta faixa operacional de -30°C a +50°C. Toda a gestão do equipamento é feita pelo aplicativo SEMS+ da GoodWe.

O carregador suporta cinco modos de operação configuráveis: carregamento rápido, prioridade para energia solar, combinação de energia solar com bateria (FV+BAT), agendamento de horário e controle de carga dinâmico. Este último modo é particularmente relevante para a plataforma, pois permite que o sistema ajuste automaticamente a potência de carregamento conforme a disponibilidade da rede elétrica do condomínio, evitando sobrecarga sem interromper as sessões ativas.

Para a autenticação dos usuários, o equipamento aceita três métodos: cartão RFID, sendo que dois cartões já acompanham o kit de instalação, aplicativo SEMS+ via rede Wi-Fi ou LAN, e início automático, que pode ser configurado pelo gestor para dispensar qualquer autenticação. As interfaces de comunicação disponíveis no hardware são Wi-Fi, RS-485 com duas portas, LAN e RFID. O Bluetooth não é uma interface direta do carregador, mas está presente no aplicativo SEMS+ para pareamento e configuração inicial.

A segunda camada é a de conectividade, responsável por transportar os dados do carregador até o servidor da plataforma. O protocolo nativo do GW7K-HCA-20, conforme confirmado no datasheet oficial, é o Modbus TCP. Esse protocolo funciona como uma tabela de registros: cada posição da tabela armazena um valor diferente, como tensão, corrente ou energia acumulada, e o servidor consulta esses registros periodicamente pela rede local. É o protocolo usado para leitura de telemetria em baixo nível.

O OCPP, sigla para Open Charge Point Protocol, é o padrão aberto de mercado para comunicação entre carregadores e sistemas de gerenciamento centralizados. Ele define mensagens específicas para cada evento de uma sessão: o carregador se apresenta ao sistema com BootNotification ao ser ligado, o usuário é validado por Authorize, a sessão tem início registrado por StartTransaction, durante a sessão o carregador envia leituras periódicas de consumo por MeterValues, e o encerramento é registrado por StopTransaction. Essa separação de eventos é o que permite rastrear cada sessão individualmente com precisão.

A terceira camada é a de aplicação, que é o núcleo da plataforma. É aqui que os dados brutos se transformam em informação útil. Essa camada é composta por quatro componentes principais. O primeiro é o CSMS, o sistema de gerenciamento das estações de recarga, que recebe os eventos do carregador em tempo real e é o ponto central de controle das sessões. O segundo é o serviço de ingestão e processamento, que normaliza, valida e persiste os dados no banco da plataforma. O terceiro é o motor de rateio, que aplica as regras de cálculo de consumo individual e gera os dados de faturamento. O quarto é o módulo de IA, que executa os modelos de machine learning para previsão de demanda e detecção de anomalias, descrito em detalhe na seção de aprofundamento abaixo.

A quarta camada é a de apresentação, que materializa os dados processados em interfaces digitais para dois perfis diferentes. O painel do gestor oferece visão consolidada de todas as sessões do mês, gráficos de consumo por unidade e por período, alertas gerados pelo módulo de IA e exportação de relatórios e faturas. O aplicativo do usuário mostra o histórico individual de sessões e consumo, permite autenticação para iniciar sessões e exibe a fatura mensal com detalhamento de uso.

O caminho que um dado percorre desde a conexão do veículo até a geração da fatura passa por seis etapas com transformações distintas em cada uma.
Na primeira etapa, o usuário se autentica junto ao carregador por cartão RFID, pelo aplicativo SEMS+ ou por início automático, quando configurado. O carregador envia uma mensagem Authorize ao CSMS, que valida a identidade no banco de dados e responde com Accepted ou Blocked. Com a autorização confirmada, o carregador emite StartTransaction com o timestamp de início e a leitura inicial do medidor em kWh acumulado.

Na segunda etapa, durante toda a sessão, o carregador envia mensagens MeterValues a intervalos regulares, geralmente a cada 60 segundos. Cada mensagem contém potência instantânea em kW, tensão, corrente, energia acumulada no período e status do conector. O serviço de ingestão normaliza e persiste esses registros como série temporal no banco de dados.

Na terceira etapa, quando o usuário desconecta o veículo ou a sessão atinge o tempo máximo configurado, o carregador emite StopTransaction com o timestamp de fim e a leitura final do medidor. O consumo bruto da sessão é calculado subtraindo a leitura inicial da leitura final, e o status da sessão é atualizado para concluída ou interrompida, dependendo do motivo do encerramento.

Na quarta etapa, o módulo de IA processa os dados da sessão encerrada junto ao histórico acumulado do mês. Essa etapa é descrita em detalhe na seção de aprofundamento.

Na quinta etapa, ao final do mês ou sob demanda do gestor, o motor de rateio consolida todas as sessões do período, aplica as regras de cálculo definidas pelo modelo adotado e lida com os casos excepcionais descritos abaixo.

Na sexta etapa, o sistema gera a fatura individual com detalhamento completo: número de sessões, kWh total consumido, valor calculado com base na tarifa vigente e total a pagar. A fatura é disponibilizada no aplicativo do usuário e o gestor recebe o relatório consolidado.


O modelo adotado pela equipe é o rateio por consumo individual medido em kWh, com ajuste por tarifa horária. A escolha por esse modelo se justifica pela sua precisão e pela sua transparência: cada usuário paga exatamente pela energia que consumiu, sem estimativas ou divisões proporcionais arbitrárias.

As variáveis utilizadas no cálculo são cinco. A primeira é o kWh por sessão, que é a energia efetivamente entregue ao veículo medida pelo medidor interno do GW7K-HCA-20. A segunda é a tarifa de energia em R$/kWh, que corresponde à tarifa vigente da distribuidora local, com distinção entre horário de ponta e fora de ponta. A terceira é o fator de demanda, que é o percentual de uso em horário de ponta, entre 18h e 21h, onde a tarifa é mais cara, calculado sessão a sessão. A quarta é o custo fixo mensal, que é a parcela da taxa condominial relacionada à infraestrutura de recarga, como manutenção e depreciação do equipamento, rateada igualmente entre os usuários ativos no mês. A quinta é o identificador da unidade condominial, que vincula todas as sessões de uma unidade a um único responsável pelo pagamento, independentemente de quantos veículos ela tenha.

A fórmula de cálculo da fatura individual é a seguinte:

```
Fatura da unidade = soma(kWh por sessão × tarifa ajustada) + custo fixo mensal / número de usuários ativos
```

Onde a tarifa ajustada é igual à tarifa base somada ao produto do fator de demanda pelo adicional de ponta. Essa lógica garante que usuários que carregam majoritariamente em horário de ponta paguem proporcionalmente mais, o que cria um incentivo natural para deslocar o uso para períodos de menor custo.

Para os casos excepcionais, o modelo funciona da seguinte forma. Quando uma sessão é interrompida, o consumo medido até o momento da interrupção é cobrado normalmente, pois a energia já foi entregue ao veículo independentemente do motivo do encerramento. O status de interrompida é registrado para auditoria, e se a interrupção foi causada por falha do equipamento, identificada pelo módulo de IA de detecção de anomalias, o gestor pode estornar a sessão manualmente. Quando um usuário não carregou no mês, a parcela variável de consumo em kWh é zero e ele não paga pela energia. A parcela do custo fixo só é cobrada se o usuário tem acesso ativo no sistema, com RFID cadastrado, e usuários com acesso suspenso são excluídos do rateio do custo fixo. Quando uma unidade tem dois veículos, o consumo de todas as sessões de ambos é somado e o cálculo é feito sobre o total da unidade, não por veículo, o que simplifica a gestão e evita disputas internas. Por fim, o sistema consulta mensalmente a bandeira tarifária vigente da ANEEL, verde, amarela ou vermelha, e ajusta automaticamente o valor base do kWh antes de calcular as faturas do período.

### Aprofundamento (B) — Definição do papel da IA

O condomínio não tem como saber, sem um modelo preditivo, quanto de energia os carregadores vão consumir nos próximos dias ou semanas. Sem essa informação, o gestor não consegue negociar a demanda contratada com a distribuidora. Contratar menos do que o necessário gera multa. Contratar muito mais gera desperdício. A previsão de demanda resolve esse problema diretamente.
A técnica utilizada é a regressão sobre séries temporais. Regressão é um tipo de modelo que aprende a relação entre variáveis de entrada e um valor de saída numérico. No caso, as entradas são o histórico de sessões com seus respectivos horários, dias da semana, consumo em kWh e variáveis de contexto como temperatura e feriados, e a saída é a estimativa de consumo futuro. Modelos como ARIMA, Prophet e XGBoost são candidatos para essa tarefa.

Os dados necessários para treinar o modelo são o histórico de sessões com timestamp de início e fim, kWh consumido por sessão, dia da semana, horário de início e dados de temperatura. O dataset do Kaggle de Electric Vehicle Charging Sessions, com registros reais de frota corporativa nos EUA, pode ser usado para prototipação inicial enquanto o histórico real do carregador da FIAP não está disponível.
O impacto esperado é a redução de custos com tarifas de demanda, a possibilidade de notificar usuários sobre os horários de menor custo para recarga e a geração de dados preditivos que o gestor pode usar para planejar manutenções preventivas nos períodos de menor uso previsto.

Sessões com comportamento atípico são difíceis de identificar manualmente em qualquer volume de dados. Consumo muito acima do esperado para um determinado veículo, duração anormalmente longa, interrupções frequentes em sequência ou uso do carregador por identidades não cadastradas são exemplos de situações que passam despercebidas sem monitoramento automatizado. Fraude por cartão RFID clonado, falha no equipamento entregando energia incorreta e consumo por dispositivos não relacionados a veículos elétricos são casos reais que esse módulo se propõe a capturar.

A técnica utilizada é a detecção de anomalias com algoritmos não supervisionados, sendo o Isolation Forest o candidato principal. Diferente dos modelos supervisionados, que precisam de exemplos rotulados de fraude para aprender, o Isolation Forest aprende o padrão normal das sessões e identifica automaticamente os pontos que se afastam significativamente desse padrão. O modelo pode ser complementado com regras determinísticas simples, como emitir alerta quando o consumo de uma sessão for superior ao dobro da média histórica do usuário.
Os dados necessários são o histórico de sessões por usuário com kWh, duração e horário, o modelo do veículo declarado na plataforma para validar se o consumo está dentro da capacidade da bateria, os registros granulares de MeterValues com a curva de potência ao longo da sessão e os logs de erro do equipamento reportados via StatusNotification.

O impacto esperado é a proteção contra fraudes e uso indevido da infraestrutura compartilhada, a identificação precoce de falhas no equipamento e o aumento da confiança dos usuários no sistema de rateio, pois anomalias são sinalizadas e investigadas antes da emissão da fatura.
Os dois módulos de IA utilizam os dados já coletados pelo fluxo principal de sessões, sem exigir qualquer infraestrutura adicional de sensores. O aprendizado é incremental: quanto mais sessões acumuladas, mais precisas ficam as previsões e mais calibrada fica a detecção de anomalias.


---

## Diagrama de Arquitetura

<img width="2720" height="2480" alt="ev_chargeops_arquitetura" src="https://github.com/user-attachments/assets/60e15c27-2470-45ed-8b62-5ae5f033dd27" />


> O diagrama representa as quatro camadas da plataforma, desde o carregador físico até as interfaces de acesso do gestor e do usuário.


---

## Papel da IA na Solução

A inteligência artificial na plataforma EV ChargeOps resolve dois problemas que não têm solução manual em escala. O primeiro é saber quanto de energia os carregadores vão consumir nos próximos dias. O segundo é identificar sessões com comportamento fora do padrão antes que elas gerem cobranças incorretas ou prejuízos para o condomínio.

Sem um modelo preditivo, o gestor não tem como estimar com precisão o consumo futuro dos carregadores. Dessa forma, essa incerteza tem custo direto, pois contratar menos demanda do que o necessário junto à distribuidora gera multa, e contratar muito mais gera desperdício. O módulo de previsão resolve isso aprendendo o padrão de uso a partir do histórico de sessões, que já inclui horário de início, dia da semana, duração e kWh consumido, e produz estimativas de consumo futuro. A técnica utilizada é regressão sobre séries temporais, com três algoritmos candidatos para avaliação durante a sprint 02, sendo eles ARIMA, Prophet e XGBoost. O de melhor desempenho para o perfil dos dados disponíveis será selecionado. Enquanto o histórico real do carregador da FIAP não estiver disponível em volume suficiente, o dataset de Electric Vehicle Charging Sessions do Kaggle será usado para prototipação.

Em qualquer volume de dados, sessões com comportamento atípico passam despercebidas sem monitoramento automatizado. Consumo muito acima do esperado para o veículo declarado pelo usuário, durações anormalmente longas, interrupções frequentes em sequência e uso do carregador por identidades não cadastradas são exemplos de situações que o módulo de detecção de anomalias se propõe a capturar. A técnica utilizada é o Isolation Forest, um algoritmo não supervisionado que aprende o que é normal a partir do histórico e identifica os registros que se afastam desse padrão, sem precisar de exemplos rotulados de fraude para funcionar. Ele será complementado por regras determinísticas simples, como emitir alerta quando o consumo de uma sessão superar o dobro da média histórica do usuário. Os dados que alimentam esse modelo são os mesmos já coletados pelo fluxo de sessões, incluindo histórico por usuário, registros granulares de MeterValues com a curva de potência ao longo da sessão, modelo do veículo declarado na plataforma e logs de erro do equipamento.
Os dois módulos operam sobre os dados que o fluxo principal já coleta, sem exigir sensores adicionais ou fontes externas de informação. E os dois melhoram com o tempo, pois quanto mais sessões acumuladas, mais precisa fica a previsão e mais calibrada fica a detecção de anomalias.

---

## Plano para a Sprint 02

O desenvolvimento da nossa sprint 02 seguirá quatro etapas em sequência. A ordem importa porque cada etapa entrega a base sobre a qual a próxima é construída.

A primeira etapa é a infraestrutura e a ingestão de dados. O objetivo é garantir que o sistema consiga receber os eventos do carregador, validá-los e persistir os registros de sessão de forma estruturada. Isso envolve configurar o banco de dados com o esquema de entidades definido na Frente 3, que cobre usuário, unidade, sessão e fatura, e implementar o serviço que recebe os eventos OCPP ou as leituras Modbus TCP e os grava como série temporal. As tecnologias desta etapa são Python, PostgreSQL e FastAPI.

A segunda etapa é o motor de rateio e a geração de faturas. Com sessões sendo registradas, essa etapa implementa a lógica de cálculo descrita na Frente 3, que inclui a soma do consumo em kWh por sessão, a aplicação da tarifa ajustada por horário de ponta, a inclusão da parcela do custo fixo mensal rateada entre os usuários ativos e o tratamento dos casos excepcionais de sessão interrompida, usuário sem carregamento no mês e unidade com dois veículos. Essa etapa também inclui a consulta automatizada à bandeira tarifária vigente da ANEEL, que ajusta o valor base do kWh antes de cada ciclo de faturamento, e a geração da fatura individual com detalhamento completo. As tecnologias são Python e PostgreSQL.

A terceira etapa são os módulos de IA. Com histórico de sessões disponível, mesmo que parcialmente simulado a partir do dataset do Kaggle, essa etapa implementa os dois modelos descritos na seção anterior. Para a previsão de demanda, os três algoritmos candidatos serão treinados e avaliados, e o de melhor desempenho será integrado à plataforma. Para a detecção de anomalias, o Isolation Forest será calibrado e combinado com as regras determinísticas de alerta. As tecnologias desta etapa são Python com as bibliotecas scikit-learn, statsmodels e Prophet.

A quarta etapa são as interfaces de acesso. Com o back-end funcionando, essa etapa entrega as telas para os dois perfis de usuário definidos na arquitetura. O painel do gestor expõe a visão consolidada das sessões do mês, os gráficos de consumo por unidade e período, os alertas gerados pelo módulo de detecção de anomalias e a exportação de relatórios e faturas. O aplicativo do usuário mostra o histórico individual de sessões, o consumo acumulado no mês e a fatura com detalhamento de uso. As tecnologias desta etapa são React no front-end e FastAPI nos endpoints que alimentam as interfaces.

---

## Fontes Consultadas

### Frente 1

- Ambar-e. Carregamento compartilhado em condomínios: como funciona e quem paga a conta. Disponível em: https://ambare.com.br/carregamento-compartilhado-em-condominios-como-funciona-e-quem-paga-a-conta/
- Zangari. Carros elétricos em condomínio: o que mudou em 2026 e como se preparar. Disponível em: https://zangari.com.br/blog/carros-eletricos-condominio/
- Migalhas. Lei 18.403/26 de SP: recarga de veículos elétricos em condomínios. Disponível em: https://www.migalhas.com.br/coluna/migalhas-edilicias/452093/lei-18-403-26-de-sp-recarga-de-veiculos-eletricos-em-condominios
- MyCond. Desafios para carregadores de carros elétricos em condomínios. Disponível em: https://mycond.com.br/desafios-para-carregadores-de-carros-eletricos-em-condominios/
- CondoCash. Carregador de carro elétrico em condomínio: instalação, custos e rateio. Disponível em: https://condocash.com.br/carregador-de-carro-eletrico-em-condominio-instalacao-custos-e-rateio/
- Canal VE. Como funciona o protocolo OCPP na recarga de carros elétricos. Disponível em: https://canalve.com.br/como-funciona-o-protocolo-ocpp-nas-recargas-de-carros-eletricos/
- Kilowatt Crew. OCPP: o guia definitivo para quem opera, integra e desenvolve infraestrutura de recarga. Disponível em: https://www.kilowattcrew.app/noticias/ocpp-open-charge-point-protocol-o-guia-definitivo
- VoltBras. Como o OCPP 1.6 facilita o carregamento elétrico. Disponível em: https://voltbras.com/ocpp-1-6-carregamento/
- Power2Go. Cobrança por kWh ou assinatura mensal? O melhor modelo para recarga de carros elétricos. Disponível em: https://www.power2go.com.br/post/melhor-modelo-de-cobran%C3%A7a-para-recarga-de-carros-el%C3%A9tricos
- Sindiconet. Carro elétrico: recarregue seu veículo sem sair do condomínio. Disponível em: https://www.sindiconet.com.br/informese/carro-eletrico-mercado-coluna-de-olho-no-mercado
- ABVE — Associação Brasileira do Veículo Elétrico. Geografia da Eletromobilidade: painel de dados por região. Disponível em: https://abve.org.br/abve-data/bi-geografia-da-eletromobilidade/
- ABVE — Associação Brasileira do Veículo Elétrico. Eletropostos: painel de dados de infraestrutura de recarga no Brasil. Disponível em: https://abve.org.br/abve-data/bi-eletropostos/
- FANTONI, Roberto; NADALIN, Daniele. Recarregar para crescer: expansão de infraestrutura para veículos elétricos cria oportunidade de R$ 6,8 bi. McKinsey & Company, 12 dez. 2024. Disponível em: https://www.mckinsey.com/br/our-insights/all-insights/recarregar-para-crescer
- NeoCharge. Qual o perfil dos interessados por carros elétricos no Brasil? Publicado em 23 jan. 2023. Disponível em: https://www.neocharge.com.br/blogs/post/perfil-entusiastas-carro-eletrico-brasil

### Frente 2
- ANEEL. Resolução Normativa nº 1.000, de 7 de dezembro de 2021. Disponível em: https://www.aneel.gov.br/cedoc/ren20211000.pdf
- GoodWe. Linha HCA G2: datasheet oficial GW7K-HCA-20, monofásico 7 kW. Versão PT-V2.1, 2024. Disponível em: https://br.goodwe.com/Ftp/Downloads/Datasheet/PT/GW_HCA-G2_Datasheet-PT.pdf
- GoodWe. Plataforma SEMS+. Acesso realizado pela equipe em junho de 2026. Disponível em: https://semsplus.goodwe.com/
- Analog Devices. Full Guide to Serial Communication Protocol and RS-485. Disponível em: https://www.analog.com/en/resources/technical-articles/full-guide-to-serial-communication-protocol-and-our-rs485.html
- Analog Devices. AN-960: RS-485/RS-422 Circuit Implementation Guide. Disponível em: https://www.analog.com/en/resources/app-notes/an-960.html
- Analog Devices. RS-485: Still the Most Robust Communication. Disponível em: https://www.analog.com/en/resources/technical-articles/rs485-still-the-most-robust-communication.html
- Chipkin. RS-485 Physical Layer Reference. Disponível em: https://docs.chipkin.com/articles/rs485-physical-layer-reference/
- Wikipedia. RS-485. Disponível em: https://en.wikipedia.org/wiki/RS-485
- Intel. O que é a tecnologia Bluetooth? Disponível em: https://www.intel.com.br/content/www/br/pt/products/docs/wireless/what-is-bluetooth.html
- Tecnoblog. Bluetooth: o que é, como funciona e quais são versões da tecnologia? Disponível em: https://tecnoblog.net/responde/o-que-e-bluetooth/
- Forbes. What Is Bluetooth? The Wireless Technology Explained. Disponível em: https://www.forbes.com/sites/technology/article/what-is-bluetooth/
- Wired. The WIRED Guide to Bluetooth. Disponível em: https://www.wired.com/story/what-is-bluetooth/
- Alura. Bluetooth: o que é, tipos, segurança e bibliotecas para Flutter. Disponível em: https://www.alura.com.br/artigos/bluetooth
- Britannica. Radio-Frequency Identification (RFID). Disponível em: https://www.britannica.com/technology/RFID
- Schneider Electric. What is RFID? Advantages and disadvantages. Disponível em: https://blog.se.com/industry/machine-and-process-management/2021/06/20/rifd-what-are-its-advantages-and-disadvantages/
- Atlas RFID Store. What is RFID? How RFID Systems Work. Disponível em: https://www.atlasrfidstore.com/rfid-resources/rfid-beginners-guide/
- RFID.com. A Guide to Radio Frequency Identification (RFID). Disponível em: https://www.rfid.com/rfid-101/
- UFRJ. RFID: prós e contras. Disponível em: https://www.gta.ufrj.br/grad/07_1/rfid/RFID_arquivos/prosecontras.htm
- ArXiv. RFID Applications: An Introductory and Exploratory Study. Disponível em: https://arxiv.org/abs/1002.1179
- ArXiv. Technical Analysis of Security Infrastructure in RFID Technology. Disponível em: https://arxiv.org/abs/1505.00172
- ArXiv. RFID Exploitation and Countermeasures. Disponível em: https://arxiv.org/abs/2110.00094

### Frente 3
- GoodWe. Linha HCA G2: datasheet oficial GW7K-HCA-20, monofásico 7 kW. Versão PT-V2.1, 2024. Disponível em: https://br.goodwe.com/Ftp/Downloads/Datasheet/PT/GW_HCA-G2_Datasheet-PT.pdf
- GoodWe. Plataforma SEMS+. Acesso realizado pela equipe em junho de 2026. Disponível em: https://semsplus.goodwe.com/
- Open Charge Alliance. OCPP 1.6 Specification, 2015. Disponível em: https://www.openchargealliance.org/protocols/ocpp-16/
- Liu, F. T.; Ting, K. M.; Zhou, Z.-H. Isolation Forest. IEEE International Conference on Data Mining, 2008.
- Meta. Prophet: Forecasting at Scale. Disponível em: https://github.com/facebook/prophet
- Kaggle. Electric Vehicle Charging Sessions dataset. Disponível em: https://www.kaggle.com/datasets/michaelbryantds/electric-vehicle-charging-dataset

