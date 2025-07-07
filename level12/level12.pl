#!/usr/bin/env perl                          
# localhost:4646                            # Comentario que dice en qué puerto va el programa
use CGI qw{param};                          # Importa herramientas para hacer páginas web
print "Content-type: text/html\n\n";       # Le dice al navegador que esto es una página web

sub t {                                     # Crea una función llamada "t"
  $nn = $_[1];                              # Guarda y en la variable "nn"
  $xx = $_[0];                              # Guarda x en la variable "xx"
  $xx =~ tr/a-z/A-Z/;                       # Convierte todas las letras a mayúsculas
  $xx =~ s/\s.*//;                          # Borra todo lo que viene después del primer espacio
  @output = `egrep "^$xx" /tmp/xd 2>&1`;    # Busca líneas que empiecen con "xx" en el archivo /tmp/xd
  foreach $line (@output) {                 # Para cada línea encontrada, haz esto:
      ($f, $s) = split(/:/, $line);         # Divide la línea en dos partes usando ":" como separador
      if($s =~ $nn) {                       # Si la segunda parte contiene lo que está en "nn"
          return 1;                         # Devuelve "1" (significa "sí" o "verdadero")
      }
  }
  return 0;                                 # Si no encuentra nada, devuelve "0" (significa "no" o "falso")
}

sub n {                                     # Crea una función llamada "n"
  if($_[0] == 1) {                          # Si el parámetro es igual a 1
      print("..");                          # Imprime dos puntos
  } else {                                  # Si no
      print(".");                           # Imprime un solo punto
  }    
}

n(t(param("x"), param("y")));              # Ejecuta: toma los valores "x" e "y" de la web, los pasa a función "t", y el resultado a función "n"