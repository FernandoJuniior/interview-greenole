# language: pt
  Funcionalidade: Carrinho de Compras e Checkout
    Eu como analista
    Posso acessar o apliocativo de comércio eletrônico
    Para poder validar as funcionalidades do carrinho

  Cenário: Validar fluxo de compra
    Dado que estou na página de detalhes do produto
    Quando clico no botão "Adicionar ao Carrinho"
    E clico no link "Carrinho"
    E vejo a lista de itens no carrinho
    E verifico os valores e informaçoes sobre o produto
    E preencho os campos de envio e pagamento com informações válidas
    E confirmo o pedido
    Então as informações do pedido estão corretas
    E recebo uma confirmação de pedido com sucesso

  Esquema do Cenário: Validar a ação de incremento de protudos no carrinho
    Dado que estou na página de detalhes do produto
    Quando clico no botão "Adicionar ao Carrinho"
    E clico no link "Carrinho"
    E incremento <numero> vezes
    Então a quantidade de itens do produto adcionado deve ser altarada para <quantidade> vezes
    E o valor total da compra é atualizado com sucesso

    Exemplos:
   |numero    |quantidade   |
   |1         |2            |
   |5         |6            |
   |8         |9            |
   |15        |16           |
   |50        |51           |

  Cenário: Tentar adicionar item fora de estoque
    Dado que estou na página de detalhes de um produto fora de estoque
    Quando clico no botão "Adicionar ao Carrinho"
    Então recebo uma mensagem de erro informando que o item está fora de estoque

  Cenário: Tentar adicionar item com quantidade inválida
    Dado que estou na página de detalhes do produto
    Quando tento adicionar um item com quantidade zero ou negativa
    Então recebo uma mensagem de erro informando que a quantidade é inválida

  Cenário: Visualizar carrinho vazio
    Dado que meu carrinho está vazio
    Quando clico no link "Carrinho"
    Então vejo uma mensagem informando que o carrinho está vazio

  Cenário: Iniciar o processo de pagamento a partir do carrinho
    Dado que estou no carrinho de compras
    Quando clico no botão "Pagar"
    E sou direcionado para a página de checkout
    Então todas as informações e valores de checkout estão corretas


  Cenário: Tentar fazer o checkout sem itens no carrinho
    Dado que estou na página de checkout
    Quando tento confirmar o pedido
    Então recebo uma mensagem de erro informando que não há itens no carrinho

  Cenário: Tentar fazer o checkout com informações de pagamento inválidas
    Dado que estou na página de checkout
    Quando preencho os campos de pagamento com informações inválidas
    E tento confirmar o pedido
    Então recebo uma mensagem de erro informando que as informações de pagamento são inválidas

  Cenário: Verificar o resumo do pedido antes de finalizar o pagamento
    Dado que estou na página de checkout com itens no carrinho
    Quando reviso o resumo do pedido
    Então o resumo contém os itens corretos, quantidades e valores

  Cenário: Finalizar o pagamento com sucesso
    Dado que estou na página de checkout com informações de pagamento válidas
    Quando confirmo o pedido
    Então recebo uma confirmação de pagamento bem-sucedida

  Cenário: Verificar a confirmação de pedido após o checkout
    Dado que finalizei o pagamento com sucesso
    Quando sou redirecionado para a página de confirmação de pedido
    Então vejo os detalhes do pedido e um número de pedido
