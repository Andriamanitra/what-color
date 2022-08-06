FROM racket/racket:latest
WORKDIR /app
COPY info.rkt /app/
RUN raco pkg install --auto
COPY what-color.rkt /app/
COPY static/ /app/static/
CMD ["racket", "what-color.rkt"]
EXPOSE 8000
