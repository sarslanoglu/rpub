<div id="top"></div>
<br />
<div align="center">
  <h3 align="center">RPUB - Simple mock API</h3>

  <p align="center">
    Enpower your mock experience with rpub!
  </p>
</div>

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#examples">Examples</a></li>
    <li><a href="#testing">Testing</a></li>
  </ol>
</details>

## About The Project

Why project name is rpub? It's easy. These kind of public repos are open to search by other users. So for protecting project name
from search engines a simple letter substitution cipher [ROT 13](https://en.wikipedia.org/wiki/ROT13) is used here. If you are lazy to
change letters like me just use [this website](https://rot13.com/)

rpub is a simple endpoint mocker with 4 different endpoints to create/update/get/delete endpoints and many more endpoints to serve for mocking when
user created more.

## Getting Started

### Installation

1. Clone the repo
   ```sh
   $ git clone https://github.com/sarslanoglu/rpub.git
   ```
2. Get inside folder
   ```sh
   $ cd rpub
   ```
3. Install gems
   ```sh
   $ bundle install
   ```
4. Create and migrate database & test database
   ```sh
   $ rails db:create
   $ rails db:migrate
   $ rails db:migrate RAILS_ENV=test
   ```

App is now ready to use. Next step will be about usage.

<p align="right">(<a href="#top">back to top</a>)</p>

## Usage

In order to start using first serve rails to your local

```sh
$ rails s
```

* GET    http://localhost:3000/endpoints to get all endpoints
* POST   http://localhost:3000/endpoints to create a new endpoint
* PATCH  http://localhost:3000/endpoints{/:id} to update id matched endpoint
* DELETE http://localhost:3000/endpoints{/:id} to delete id matched endpoint

After creating endpoint objects all created VERB & PATH pairs will be available on API. You can find many examples about requests on examples section.

Endpoint model is fairly simple and looks like this:

    Endpoint {
      id    Unique string field (system auto assigns, no user interaction)
      verb  String (required from user input)
      path  String (required from user input)

      response {
        code    Integer (required from user input)
        headers Hash<String, String> (optional from user input)
        body    String (optional from user input)
      }
    }

 There is a uniqueness relation on verb & path. This means that if there is a matching pair in the system new one can't be added. Previous one should be
 updated instead.

 Example endpoint object on request:

     {
        "data": {
            "type": "endpoints",
            "attributes": {
                "verb": "GET",
                "path": "/greeting",
                "response": {
                  "code": 200,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }

<p align="right">(<a href="#top">back to top</a>)</p>

## Examples

<details>
  <summary>List endpoints</summary>
  <markdown>

#### Request

    GET /endpoints HTTP/1.1
    Accept: application/vnd.api+json

#### Response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
        "data": [
            {
                "type": "endpoints",
                "id": "12345",
                "attributes": [
                    "verb": "GET",
                    "path": "/greeting",
                    "response": {
                      "code": 200,
                      "headers": {},
                      "body": "\"{ \"message\": \"Hello, world\" }\""
                    }
                ]
            }
        ]
    }
  </markdown>
</details>

<details>
  <summary>Create endpoint</summary>
  <markdown>

#### Request

    POST /endpoints HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "attributes": {
                "verb": "GET",
                "path": "/greeting",
                "response": {
                  "code": 200,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }

#### Response

    HTTP/1.1 201 Created
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "GET",
                "path": "/greeting",
                "response": {
                  "code": 200,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }
  </markdown>
</details>

<details>
  <summary>Update endpoint</summary>
  <markdown>

#### Request

    PATCH /endpoints/12345 HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345"
            "attributes": {
                "verb": "POST",
                "path": "/greeting",
                "response": {
                  "code": 201,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, everyone\" }\""
                }
            }
        }
    }


#### Response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "POST",
                "path": "/greeting",
                "response": {
                  "code": 201,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, everyone\" }\""
                }
            }
        }
    }
  </markdown>
</details>

<details>
  <summary>Delete endpoint</summary>
  <markdown>

#### Request

    DELETE /endpoints/12345 HTTP/1.1
    Accept: application/vnd.api+json

#### Response

    HTTP/1.1 204 No Content
  </markdown>
</details>

<details>
  <summary>Sample scenario</summary>
  <markdown>

#### 1. Create an endpoint

    POST /endpoints HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "attributes": {
                "verb": "GET",
                "path": "/hello",
                "response": {
                    "code": 200,
                    "headers": {
                        "Content-Type": "application/json"
                    },
                    "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }

    HTTP/1.1 201 Created
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "GET",
                "path": "/hello",
                "response": {
                    "code": 200,
                    "headers": {
                        "Content-Type": "application/json"
                    },
                    "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }

#### 2. Send request to recently created endpoint

    GET /hello HTTP/1.1
    Accept: application/json

    HTTP/1.1 200 OK
    Content-Type: application/json

    { "message": "Hello, world" }

  </markdown>
</details>

<p align="right">(<a href="#top">back to top</a>)</p>

## Testing

To run all tests just run

```sh
$ bundle exec rspec
```

To run rubocop style checker just run

```sh
$ rubocop
```

<p align="right">(<a href="#top">back to top</a>)</p>
