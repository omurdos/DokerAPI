# Get base SDK image from Microsoft
FROM mcr.microsoft.com/dotnet/sdk:6.0 as buld-env
WORKDIR /app

# Copy csProject file and restore any dependancies.
COPY *.csproj ./
RUN dotnet restore

# Copy project files and build our release
COPY . ./
RUN dotnet publish -c release -o out

# Generate runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
EXPOSE 80
COPY --from=buld-env /app/out .
ENTRYPOINT [ "dotnet" , "DokerAPI.dll" ]