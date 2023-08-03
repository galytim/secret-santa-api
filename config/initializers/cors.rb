
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://secret-santa-sevsu.vercel.app"

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose:  %w[Authorization Uid]
  end
end
