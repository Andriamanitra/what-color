# What's this color?!

The goal of this web app is to figure out where people think different
different colors lie in the RGB color space. To achieve this it shows
users random colors and asks them what they would call that color.


## Why?

If I ever manage to collect a nice set of data with this (doubtful) I'll
make sure to open source it. A big enough data set could tell a lot about
how we think about colors and even cultural differences in color perception.
Although I don't plan on collecting any demographical data, I intend to
encourage people to answer in their own native language. For example maybe
English word "blue" occupies different parts of the spectrum than the
Russian word "синий"?


## How do I run this thing?

### Requirements

You will need [racket](https://racket-lang.org/).
After installing racket you can install the required packages
([`forms-lib`](https://docs.racket-lang.org/forms/index.html),
 [`db-lib`](https://docs.racket-lang.org/db/index.html))
with raco:
```
raco pkg install --auto
```

### Initialize the database

```
sqlite3 colornames.db < initdb.sql
```

### Run the server

```
racket what-color.rkt
```
The application will be listening on `http://localhost:8000/whatcolor` by default.

### Export data from sqlite3

```
sqlite3 -csv colornames.db 'SELECT * FROM colornames' > colornames.csv
```

### Or alternatively, using Docker:

```
docker build --tag whatcolor .
sqlite3 colornames.db < initdb.sql
docker run --rm -it -v $PWD/colornames.db:/app/colornames.db -p 8000:8000 whatcolor:latest
```
