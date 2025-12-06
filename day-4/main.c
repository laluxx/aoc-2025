#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

char* parse(char* in, int* h, int* w) {
    *h = 0; *w = 0;
    for (int i = 0; in[i]; i++) {
        if (in[i] == '\n') {
            if (!*w) *w = i;
            (*h)++;
        }
    }
    char* g = malloc(*h * *w + 1);
    int k = 0;
    for (int i = 0; in[i]; i++) {
        if (in[i] != '\n') g[k++] = in[i];
    }
    g[k] = '\0';
    return g;
}

char* moore(char* g, int h, int w, int r, int c) {
    char* n = malloc(10);
    int d[] = {-1,-1,-1,0,0,0,1,1,1,-1,0,1,-1,0,1,-1,0,1}, k = 0;
    for (int i = 0; i < 9; i++) {
        int y = r + d[i], x = c + d[i+9];
        if (y >= 0 && y < h && x >= 0 && x < w) n[k++] = g[y*w+x];
    }
    n[k] = '\0';
    return n;
}

size_t count_paper_rolls(char *string) {
    size_t output = 0;
    size_t i = 0;
    while (string[i] != '\0') {
        if (string[i] == '@') output++;
        i++;
    }
    return output;
}

void part1(char* p, int x, int y, char* grid, int rows, int cols) {
    
    size_t result = 0;

    while (*p != '\0') {
        if (*p == '\n') {
            x = 0;
            y++;
        } else {
            if (*p == '@') {
                char* moore_string = moore(grid, rows, cols, y, x);
                size_t paper_rolls_count = count_paper_rolls(moore_string);
                // Subtract 1 for the one we are on
                if (paper_rolls_count - 1 < 4) {
                    result++;
                }
                free(moore_string);
            }
            x++;
        }
        p++;
    }

    printf("Result: %zu\n", result);

}

void part2(char* input, int* x, int* y, char** grid_ptr, int* rows, int* cols) {
    size_t result = 0;
    bool changed = true;
    
    while (changed) {
        changed = false;
        *x = 0;
        *y = 0;
        char* p = input;
        
        // Recreate grid from modified input
        free(*grid_ptr);
        *grid_ptr = parse(input, rows, cols);
        
        while (*p != '\0') {
            if (*p == '\n') {
                *x = 0;
                (*y)++;
            } else {
                if (*p == '@') {
                    char* moore_string = moore(*grid_ptr, *rows, *cols, *y, *x);
                    size_t paper_rolls_count = count_paper_rolls(moore_string);
                    if (paper_rolls_count - 1 < 4) {
                        *p = '.';
                        changed = true;
                        result++;
                    }
                    free(moore_string);
                }
                (*x)++;
            }
            p++;
        }
    }

    printf("Result: %zu\n", result);
}

int main() {
    FILE* finput = fopen("./input.txt", "r");
    if (!finput) {
        perror("Error opening input.txt");
        return 1;
    }
    
    size_t bs = 1024;
    char chunk[bs];
    char* input = malloc(1);
    input[0] = '\0';
    
    while (fgets(chunk, bs, finput) != NULL) {
        input = realloc(input, strlen(input) + strlen(chunk) + 1);
        strcat(input, chunk);
    }
    fclose(finput);
    
    int rows, cols;
    char* grid = parse(input, &rows, &cols);
    
    int x = 0, y = 0;
    char* p = input;

    part1(p, x, y, grid, rows, cols);
    part2(p, &x, &y, &grid, &rows, &cols);

    free(grid);
    free(input);
    return 0;
}
