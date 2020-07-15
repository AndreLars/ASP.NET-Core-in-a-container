#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-nanoserver-1803 AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-nanoserver-1803 AS build
WORKDIR /src
COPY ["ASP.NET-Core-in-a-container.csproj", "./"]
RUN dotnet restore "./ASP.NET-Core-in-a-container.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ASP.NET-Core-in-a-container.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ASP.NET-Core-in-a-container.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ASP.NET-Core-in-a-container.dll"]
