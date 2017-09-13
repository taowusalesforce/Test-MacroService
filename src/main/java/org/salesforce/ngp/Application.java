package org.salesforce.ngp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

}

//run application
//./mvnw spring-boot:run

//create a Person
//curl -i -X POST -H "Content-Type:application/json" -d "{  \"firstName\" : \"Frodo\",  \"lastName\" : \"Baggins\" }" http://localhost:8080/people

//get People
//curl http://localhost:8080/people

//get Person
//curl http://localhost:8080/people/1

//find all the custom queries
//curl http://localhost:8080/people/search

//findByLastName
//curl http://localhost:8080/people/search/findByLastName?name=Baggins

//PUT (replace)
//PUT replaces an entire record. Fields not supplied will be replaced with null. PATCH can be used to update a subset of items.
//curl -X PUT -H "Content-Type:application/json" -d "{ \"firstName\": \"Bilbo\", \"lastName\": \"Baggins\" }" http://localhost:8080/people/1

//PATCH (update)
//curl -X PATCH -H "Content-Type:application/json" -d "{ \"firstName\": \"Bilbo Jr.\" }" http://localhost:8080/people/1

//DELETE
//curl -X DELETE http://localhost:8080/people/1