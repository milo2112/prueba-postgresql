
 /*
 **********************************************************************************************************
 *                                                                                                        *
 *                                      Comienzo desafio 4 - Prueba SQL                                   *
 *                                                                                                        *
 **********************************************************************************************************
 */
 --                              Pre-work paso 1: creación de base de datos 
CREATE DATABASE pruebasql_milton_rosas;
 --                              Fin paso 1: Nombre base de datos creada = pruebasql_milton_rosas
 ------------------------------------------------------------------------------------------------------------
 
 
 --                              Conectando a la base de datos pruebasql_milton_rosas...'
\c pruebasql_milton_rosas;
 --                              Conectado a la base de datos...'
 ------------------------------------------------------------------------------------------------------------'
 
 
 /*
 *************************************************************************************************'
 *                                                	                                             *'
 *              			Inicio de requerimientos del desafio   		                         *'
 *                                                                                     			 *'
 ***********************************************************************************************'
 */
 --Requerimiento 1:  Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves primarias, foráneas y tipos de datos.

CREATE TABLE IF NOT EXISTS peliculas(id SERIAL, nombre varchar(255), anno int, PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS tags(id SERIAL, tag varchar(32), PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS peliculas_tags(id SERIAL, peliculas_id int, tags_id int, PRIMARY KEY (id), FOREIGN KEY (peliculas_id) REFERENCES peliculas (id), FOREIGN KEY (tags_id) REFERENCES tags (id));
 
 ------------------------------------------------------------------------------------------------------------
 
 --Requerimiento 2: Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la segunda película debe tener 2 tags asociados.
 
INSERT INTO peliculas(nombre, anno) VALUES ('nombre_pelicula_1', 2005), ('nombre_pelicula_2', 1990), ('nombre_pelicula_3', 1997), ('nombre_pelicula_4', 2001), ('nombre_pelicula_5', 2015); 

INSERT INTO tags(tag) VALUES ('Tag N°1 para pelicula_1'), ('Tag N°2 para pelicula_1'), ('Tag N°3 para pelicula_1'), ('Tag N°1 para pelicula_2'), ('Tag N°2 para pelicula_2');

INSERT INTO peliculas_tags(peliculas_id, tags_id) VALUES (1,1), (1,2), (1,4), (2,2), (2,5);

------------------------------------------------------------------------------------------------------------
		
 
 
 --Requerimiento 3: Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0
 
									SELECT 	p.nombre AS nombre_pelicula,
											COUNT(pt.peliculas_id) AS cantidad_tags
										FROM peliculas p
											LEFT JOIN peliculas_tags pt 
											ON p.id = pt.peliculas_id
										GROUP BY p.nombre;
										--ORDER BY 1 ASC;
 				   
 -----------------------------------------------------------------------------------------------------------'
 
 --Requerimiento 4: Dado un modelo, crea las tablas correspondientes respetando los nombres, tipos, claves' primarias y foráneas y tipos de datos.
 
CREATE TABLE IF NOT EXISTS preguntas(id SERIAL, pregunta varchar(255), respuesta_correcta varchar, PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS usuarios(id SERIAL, nombre varchar(255), edad int, PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS respuestas(id SERIAL, respuesta varchar(255), usuarios_id int, preguntas_id int, PRIMARY KEY (id), FOREIGN KEY (usuarios_id) REFERENCES usuarios (id), FOREIGN KEY (preguntas_id) REFERENCES preguntas (id));
  
 ------------------------------------------------------------------------------------------------------------'
/* 	
 Requerimiento 5: Agrega 5 usuarios y 5 preguntas.'
    a.La primera pregunta debe estar respondida correctamente dos veces, por dos usuarios diferentes.
    b.La segunda pregunta debe estar contestada correctamente solo por un usuario.
    c.Las otras tres preguntas deben tener respuestas incorrectas.
    
    Contestada correctamente significa que la respuesta indicada en la tabla respuestas es exactamente igual al texto indicado en la tabla de preguntas.
 */
 
						INSERT INTO usuarios(nombre, edad) VALUES ('nombre_1', 21), ('nombre_2', 22), ('nombre_3', 23), ('nombre_4', 24), ('nombre_5', 15); 
							
						INSERT INTO preguntas(pregunta, respuesta_correcta) VALUES ('pregunta_1 color', 'respuesta_1 azul'), ('pregunta_2 numero', 'respuesta_2 21'), ('pregunta_3 ciudad', 'respuesta_3 paris'), ('pregunta_4 nombre', 'respuesta_4 maite'), ('pregunta_5 mascota', 'respuesta_5 gato');
							
						INSERT INTO respuestas(respuesta, usuarios_id, preguntas_id) VALUES ('respuesta_1 azul', 1, 1), ('respuesta_1 azul', 2, 1), ('respuesta_2 21', 3, 2), ('respuesta_3 Chile', 4, 3), ('respuesta_4 Milton', 5, 4);
 
 -----------------------------------------------------------------------------------------------------------'
 
 --Requerimiento 6: Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).'
 
					SELECT u.nombre, COUNT(r.id) AS cant_respuestas_correctas 
						FROM respuestas r
							INNER JOIN preguntas p
							ON r.preguntas_id = p.id and r.respuesta = p.respuesta_correcta
							RIGHT JOIN usuarios u 
							ON r.usuarios_id = u.id
						GROUP BY u.nombre;

 -----------------------------------------------------------------------------------------------------------
 
 --Requerimiento 7: Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente.
						
						SELECT p.pregunta, COUNT(r.usuarios_id) 
						FROM preguntas p
							LEFT JOIN respuestas r 
							ON p.id = r.preguntas_id and p.respuesta_correcta = r.respuesta
							GROUP BY p.pregunta;
					
 ------------------------------------------------------------------------------------------------------------
 
 --Requerimiento 8: Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la implementación borrando el primer usuario.'

						SELECT * FROM usuarios;
						SELECT * FROM respuestas;
						
						\d respuestas; --identificamos la constraint
						
						ALTER TABLE respuestas DROP CONSTRAINT respuestas_usuarios_id_fkey;

						ALTER TABLE respuestas ADD CONSTRAINT cascade_delete_on_usuarios FOREIGN KEY (usuarios_id) REFERENCES usuarios(id) ON DELETE CASCADE;
						
						DELETE FROM usuarios where id = 1;
						
						SELECT * FROM usuarios;
						SELECT * FROM respuestas;
						
 ------------------------------------------------------------------------------------------------------------
 
 --Requerimiento 9: Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.
 
 						SELECT * FROM usuarios;
						
						ALTER TABLE usuarios ADD CONSTRAINT	older_than_18_check CHECK (edad >= 18 ) NOT VALID; /*evitando error debido al escaneo de valores ya existentes que no cumplen el CHECK en campo EDAD al agregar constraint */
						
						INSERT INTO usuarios(nombre, edad) VALUES ('usuario_prueba', 17);
						
						SELECT * FROM usuarios;
 
 ------------------------------------------------------------------------------------------------------------'
 
 --Requerimiento 10: Altera la tabla existente de usuarios agregando el campo email. Debe tener la restricción de ser único.'
 
  						SELECT * FROM usuarios;

						ALTER TABLE usuarios ADD COLUMN email varchar CONSTRAINT email_must_be_unique UNIQUE; 
						
						SELECT * FROM usuarios;
						
						UPDATE usuarios SET email = 'email_3@email.com' WHERE id = 3; 
						
						SELECT * FROM usuarios order by 1 asc;
						
						UPDATE usuarios SET email = 'email_3@email.com' WHERE id = 7 
 
 ------------------------------------------------------------------------------------------------------------'

 
 /*
 **********************************************************************************************************
 *                                                                                                        *
 *                                           Fin del desafio                                              *
 *                                                                                                        *
 **********************************************************************************************************
 */