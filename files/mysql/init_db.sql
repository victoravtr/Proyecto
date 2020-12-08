create table CREDENCIALES (
    usuario varchar(10) not null, 
    pass varchar(255) not null, 
    correo varchar(50) not null, 
    constraint credenciales_pk primary key (usuario)
);

create table RESET_PASS (
    correo varchar(50) not null,
    codigo varchar(255) not null,
    fecha_peticion date,
    fecha_limite date,
    constraint reset_pass_pk primary key(codigo),
    FOREIGN KEY(correo) REFERENCES CREDENCIALES(correo)
);