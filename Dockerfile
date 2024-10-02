# Use a imagem oficial do Ruby 3.3.0
FROM ruby:3.3.0

# Instale dependências do sistema
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Defina o diretório de trabalho
WORKDIR /app

# Copie o Gemfile e o Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instale as dependências do Ruby
RUN gem install bundler && bundle install

# Copie o restante da aplicação
COPY . .

# Exponha a porta 3000 para o servidor Rails
EXPOSE 3000

# Comando para executar migrações e iniciar o servidor Rails
CMD ["bash", "-c", "rails db:migrate && bundle exec rails server -b '0.0.0.0'"]
