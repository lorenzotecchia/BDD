--DROP SCHEMA v CASCADE;
CREATE SCHEMA v;


CREATE TABLE v.TARIFFE
(
    Ingresso  VARCHAR(32) NOT NULL,
    Uscita    VARCHAR(32) NOT NULL,
    KM        INTEGER NOT NULL,
    Categoria INTEGER NOT NULL,
    Costo     DOUBLE PRECISION NOT NULL,
    CONSTRAINT PK_TARIFFE PRIMARY KEY (Ingresso, Uscita, Categoria)
);

CREATE TABLE v.AUTO
(
    Targa     VARCHAR(10) NOT NULL,
    CODFIS    VARCHAR(16) NOT NULL,
    Categoria INTEGER NOT NULL,
    CONSTRAINT PK_AUTO PRIMARY KEY (Targa)
);


CREATE TABLE v.PCHECK
(
    PuntoCheck    VARCHAR(10) NOT NULL,
    VelocitaMax   INTEGER NOT NULL,

    CONSTRAINT PK_PCHECK PRIMARY KEY (PuntoCheck)
);

CREATE TABLE v.CHECK
(
    PuntoCheck VARCHAR(10) NOT NULL,
    Targa      VARCHAR(10) NOT NULL,
    Velocita   INTEGER NOT NULL,
    Data      DATE NOT NULL,
    Tempo      TIME NOT NULL,
    Infrazione BOOLEAN,

    CONSTRAINT PK_CHECK PRIMARY KEY (PuntoCheck, Targa, Data, Tempo),
    CONSTRAINT FK_PCHECK FOREIGN KEY (PuntoCheck) REFERENCES v.PCHECK (PuntoCheck),
    CONSTRAINT FK_AUTO FOREIGN KEY (Targa) REFERENCES v.AUTO (Targa)
);

CREATE TABLE v.VIAGGIO
(
    CodiceViaggio VARCHAR(10) NOT NULL,
    Targa         VARCHAR(10) NOT NULL,
    DataI         DATE NOT NULL,
    DataF         DATE,
    OraI          TIME NOT NULL,
    OraF          TIME,
    Ingresso      VARCHAR(32) NOT NULL,
    Uscita        VARCHAR(32),
    Tariffa       DOUBLE PRECISION,
    KM            INTEGER,

    CONSTRAINT PK_VIAGGIO PRIMARY KEY (CodiceViaggio),
    CONSTRAINT FK_VIAGGIO_AUTO FOREIGN KEY (Targa) REFERENCES v.AUTO (Targa),
    CONSTRAINT CK_VIAGGIO CHECK (DataF > DataI OR (DataF = DataI AND OraF > OraI)),
    CONSTRAINT CK_VIAGGIO2 CHECK (KM > 0),
    CONSTRAINT CK_VIAGGIO3 CHECK (Tariffa > 0)
);

