FROM microsoft/aspnetcore:2.0-nanoserver-sac2016 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0-nanoserver-sac2016 AS build
WORKDIR /src
COPY SampleCoreApp.sln ./
COPY SampleCoreApp.csproj ./
RUN dotnet restore -nowarn:msb3202,nu1503
COPY . .
WORKDIR /src
RUN dotnet build SampleCoreApp.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish SampleCoreApp.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "SampleCoreApp.dll"]
