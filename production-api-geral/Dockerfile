FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
#### UID DOTNET
ENV APP_UID=1654
##############
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
# COPY ["src/API/API.csproj", "src/API/"]
# COPY ["src/API.Shared/API.Shared.csproj", "src/API.Shared/"]
# COPY ["src/API.Services/API.Services.csproj", "src/API.Services/"]
# RUN dotnet restore "src/API/API.csproj"
# COPY . .
# WORKDIR "/src/src/API"
# RUN dotnet build "API.csproj" -c Release -o /app/build
 
# FROM build AS publish
# RUN dotnet publish "API.csproj" -c Release -o /app/publish
 
FROM base AS final
WORKDIR /app

USER root
#PERMISSAO na pasta da aplicacao
RUN chgrp -R 0 /app && \
    chmod -R g=u /app

# COPY --from=publish /app/publish .
ENV TZ=America/Porto_Velho
USER $APP_UID
RUN echo "Teste de escrita de arquivo." > /app/teste.txt
#ENTRYPOINT ["dotnet", "API.dll"]
### Entrypoint de teste
ENTRYPOINT ["tail", "-f", "/app/teste.txt"]