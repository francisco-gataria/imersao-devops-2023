## Como realizar o deploy da aplicação

Com o `k3d` e `kubectl` devidamente instalados na sua máquina, execute os seguintes comandos:

```bash
k3d cluster create meucluster -p "8093:30000@loadbalancer"
```

Dessa forma, conseguiremos utilizar a porta 8093 no nosso localhost e assim poderemos nos comunicar com nosso cluster k8s.

Após isso, basta aplicar o arquivo `deployment.yaml`:

```bash
kubectl apply -f deployment.yaml
```

Realizando o comando acima, você conseguirá ver os pods e os services com status `Running` escrevendo

```bash
kubectl get all
```

E também poderá acessar a página web através do endpoint abaixo:

```bash
http://localhost:8093
```
