# Use .NET SDK 2.1 to build the application
FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build

# Set the working directory
WORKDIR /app

# Copy source code and restore dependencies
COPY . .
RUN dotnet restore

# Build and publish the application
RUN dotnet publish -c Release -o /app/publish

# Use .NET Core 2.0 runtime for running the app
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://0.0.0.0:5000

# Expose the port and start the app
EXPOSE 5000
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
