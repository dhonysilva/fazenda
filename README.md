# resenha
Jornada de aprendizado do Phoenix Framework.


docker-compose run --rm phoenix mix phx.new farmcontrol

docker-compose run --rm phoenix mix ecto.create

No arquivo dev.exs, altere

http: [ip: {127, 0, 0, 1}, port: 4000],

Para

http: [ip: {0, 0, 0, 0}, port: 4000],

Execute

docker-compose up