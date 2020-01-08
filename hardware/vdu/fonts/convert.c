#include <stdio.h>
#include <stdlib.h>


char * fontlist[] = {
"Bm437_PhoenixEGA_8x16.FON",
"Bm437_Verite_8x16.FON",
"Bm437_ATI_8x16.FON",
"Bm437_ATT_PC6300.FON",
"Bm437_IBM_ISO8.FON",
"Bm437_CompaqThin_8x16.FON",
"Bm437_ToshibaLCD_8x16.FON",
"Bm437_IBM_PS2thin1.FON",
};


void convert(FILE *fpout,char *fontfile);

void main() {

    int i;
    FILE *fpout;

    fpout=fopen("font.bin","wb");
    for(i=0;i<8;i++) {
        convert(fpout,fontlist[i]);
    }
    fclose(fpout);

    exit(0);
}

void convert(FILE *fpout,char *fontfile) {
 
    FILE *fp;
    int c=0;
    int zerocpt=0;
    int count=0;
    int oldc;
    int seek=0;
    char buffer[4096];
    int i;

    fp=fopen(fontfile,"rb");
    while(!feof(fp)) {
        oldc=c;
        c=fgetc(fp);

        if (seek==0) {
            if ((c=='C') && (oldc=='C')) seek=1;
        } else {

            if (c==0) zerocpt++; else zerocpt=0;

            if (zerocpt==16) {
                fread(&buffer,255*16,1,fp);
                for(i=0;i<16;i++) fputc(0,fpout);                
                fwrite(buffer,255*16,1,fpout);
                return;
            }
        }
    }

}

