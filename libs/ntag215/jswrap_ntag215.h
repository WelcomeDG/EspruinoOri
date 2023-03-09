#ifdef USE_NTAG215
#include <stdint.h>
#include <stdbool.h>
#include "jsinteractive.h"

void jswrap_ntag215_setTagData(JsVar *);
void jswrap_ntag215_setTagBuffer(JsVar *);
void jswrap_ntag215_setTagWritten(bool);
bool jswrap_ntag215_getTagWritten(void);
bool jswrap_ntag215_fixUid(void);
void jswrap_ntag215_stopNfc();
int jswrap_ntag215_startNfc(void);
int jswrap_ntag215_restartNfc(void);
void jswrap_ntag215_setAmiiboKeys(JsVar *);
JsVar *jswrap_ntag215_unpackAmiibo(JsVar *);
JsVar *jswrap_ntag215_packAmiibo(JsVar *);
JsVar *jswrap_ntag215_updateAmiiboUID(JsVar *);
#endif
