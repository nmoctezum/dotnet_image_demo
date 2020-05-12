FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS=http://*:5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["TestDotNet.csproj", "./"]
RUN dotnet restore "./TestDotNet.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "TestDotNet.csproj" -c Release -o /app/build

FROM  mcr.microsoft.com/dotnet/core/aspnet:3.1 AS publish
RUN dotnet publish "TestDotNet.csproj" -c Release -o /app/publish

FROM  mcr.microsoft.com/dotnet/core/aspnet:3.1 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestDotNet.dll"]
