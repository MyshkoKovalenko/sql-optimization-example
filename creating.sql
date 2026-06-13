CREATE TABLE IF NOT EXISTS burgers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    calories_k INTEGER,
    price FLOAT
);

CREATE TABLE IF NOT EXISTS clients (
    id UUID PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    status VARCHAR(50) CHECK (status IN ('standard', 'premium'))
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    burger_id INTEGER,
    quantity INTEGER,
    client_id UUID,
    CONSTRAINT fk_burger
        FOREIGN KEY (burger_id) REFERENCES burgers(id),
    CONSTRAINT fk_client
        FOREIGN KEY (client_id) REFERENCES clients(id)
);