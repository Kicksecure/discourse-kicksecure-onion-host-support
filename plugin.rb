# name: discourse-kicksecure-onion-host-support
# about: load Kicksecure site on onion if used
# version: 0.1
# authors: Miguel Jacq

::ONION_HOST = "w5j6stm77zs6652pgsij4awcjeel3eco7kvipheu6mtr623eyyehj4yd.onion"
::CLEAR_HOST = "forums.kicksecure.com"

after_initialize do

  # got to patch this class to allow more hostnames
  class ::Middleware::EnforceHostname
    def call(env)
      hostname = env[Rack::Request::HTTP_X_FORWARDED_HOST].presence || env[Rack::HTTP_HOST]

      env[Rack::Request::HTTP_X_FORWARDED_HOST] = nil

      if hostname == ::ONION_HOST
        env[Rack::HTTP_HOST] = ::ONION_HOST
      else
        env[Rack::HTTP_HOST] = ::CLEAR_HOST
      end

      @app.call(env)
    end
  end
end
