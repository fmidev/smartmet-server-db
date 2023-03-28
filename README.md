# SmartMet Server DB

SmartMet Server DB is a PostgreSQL database for SmartMet Server. It has two main databases "names" and "shapes". First one contains all names for a certain installation (usually a country), such as, city names street addresses municipalities, etc. Latter one contains shape-files for maps or other visualizations for building products on SmartMet Server.

## Prerequisites

Docker and Docker Compose

## Installation

```
docker-compose up
```

## TODO

* Initialization script for adding country specific names from geonames.org into names database.
* Synchronization script for keeping names up-to-date from the source (geonames.org).
* Creation clauses of shapes database.
