# next-gen-macroservice
SpringBoot scaffolding with JPA/Hibernate and Postgres backend

For use with SalesforceFoundation/next-gen-graphql-server

Install and compile with Maven.

Update postgres connection params according to your configuration.

Start command:

./mvnw spring-boot:run

Runs a database drop-create followed by import.sql custom script for triggers and notifications which are consumed
by next-gen-graphql server.

Heroku App Test for jenkins only
