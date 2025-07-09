FROM golang:1.22-alpine AS build

WORKDIR /app

COPY ./controllers/ /app/controllers/
COPY ./database/ /app/database/
COPY ./models/ /app/models/
COPY ./routes/ /app/routes/
COPY ./main.go /app/main.go
COPY ./go.mod /app/go.mod
COPY ./go.sum /app/go.sum

RUN go build main.go

FROM alpine:latest AS production

EXPOSE 8080

WORKDIR /app

ENV PORT 8080
ENV DB_HOST postgres
ENV DB_USER root
ENV DB_PASSWORD root
ENV DB_NAME root
ENV DB_PORT 5432

COPY ./assets/ /app/assets/
COPY ./templates/ /app/templates/

COPY --from=build /app/main /app/main

CMD [ "./main" ]