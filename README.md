cctv
=====

An OTP application using Erlang Amqp client to take photo (CCTV) snapshot when a specific event is present on a Rabbitmq queue.


by default the cctv.app.src is the following:

{application, cctv,
 [{description, "An OTP application"},
  {vsn, "0.1.0"},
  {registered, []},
  {mod, {cctv_app, []}},
  {applications,
   [kernel,
    stdlib,
    turtle,
    gen_smtp,
    ranch
   ]},
  {env,[]},
  {modules, []},

  {licenses, ["Apache 2.0"]},
  {links, []}
 ]}.




Build
-----

    $ rebar3 compile
