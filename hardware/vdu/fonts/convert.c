#include <stdio.h>
#include <stdlib.h>

void main() {

    FILE *fp,*fpout;
    int c=0;
    int zerocpt=0;
    int count=0;
    int oldc;
    int seek=0;
    char buffer[4096];
    int i;

    fp=fopen("Bm437_PhoenixEGA_8x16.FON","rb");
    while(!feof(fp)) {
        oldc=c;
        c=fgetc(fp);

        if (seek==0) {
            if ((c=='C') && (oldc=='C')) seek=1;
        } else {

            if (c==0) zerocpt++; else zerocpt=0;

            if (zerocpt==16) {
                fread(&buffer,255*16,1,fp);
                fpout=fopen("font.bin","wb");
                for(i=0;i<16;i++) fputc(0,fpout);                
                fwrite(buffer,255*16,1,fpout);
                fclose(fpout);
                exit(0);
            }
        }
    }

}
