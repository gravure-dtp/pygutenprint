# -*- coding: utf-8 -*-

# $Id: $
# util.pxd
# pxd Cython C declarations for module pygutenprint.util
#
#   This program is free software; you can redistribute it and/or modify it
#   under the terms of the GNU General Public License as published by the Free
#   Software Foundation; either version 2 of the License, or (at your option)
#   any later version.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.
#
#   Provided as-is; use at your own risk; no warranty; no promises; enjoy!
#
#

#TODO: change with a cimport when extension will be write
#cdef extern from "gutenprint/curve.h":
#    #include <gutenprint/curve.h>
#    struct stp_curve:
#        pass
#    ctypedef stp_curve stp_curve_t  # The curve opaque data type. 
#    ctypedef enum stp_curve_compose_t: 
#        pass
from curve cimport stp_curve_t, stp_curve_compose_t  

#TODO: change with a cimport when extension will be write
cdef extern from "gutenprint/vars.h":
    #include <gutenprint/vars.h>
    struct stp_vars: 
        pass
    ctypedef stp_vars stp_vars_t  # The vars opaque data type.
    ctypedef struct stp_raw_t:  # Raw parameter.
        pass


# Debug macros constant
cdef enum STP_DBG:
    STP_DBG_LUT = 0x1
    STP_DBG_COLORFUNC = 0x2
    STP_DBG_INK = 0x4
    STP_DBG_PS = 0x8
    STP_DBG_PCL = 0x10
    STP_DBG_ESCP2 = 0x20
    STP_DBG_CANON = 0x40
    STP_DBG_LEXMARK = 0x80
    STP_DBG_WEAVE_PARAMS = 0x100
    STP_DBG_ROWS = 0x200
    STP_DBG_MARK_FILE = 0x400
    STP_DBG_LIST = 0x800
    STP_DBG_MODULE = 0x1000
    STP_DBG_PATH = 0x2000
    STP_DBG_PAPER = 0x4000
    STP_DBG_PRINTERS = 0x8000
    STP_DBG_XML = 0x10000
    STP_DBG_VARS = 0x20000
    STP_DBG_DYESUB = 0x40000
    STP_DBG_CURVE = 0x80000
    STP_DBG_CURVE_ERRORS = 0x100000
    STP_DBG_PPD = 0x200000
    STP_DBG_NO_COMPRESSION = 0x400000

#define STP_SAFE_FREE(x)            \
#    do                        \
#    {                        \
#      if ((x))                    \
#        stp_free((char *)(x));            \
#      ((x)) = NULL;                    \
#    } while (0)
#cdef void STP_SAFE_FREE(int x)


cdef extern from "gutenprint/util.h":

    # extern int stp_init(void);
    bint stp_init()
    
    # extern const char *stp_set_output_codeset(const char *codeset);
    char* stp_set_output_codeset(char* codeset)
    
    # extern stp_curve_t *stp_read_and_compose_curves(const char *s1, const char *s2,
    #                                                 stp_curve_compose_t comp,
    #                                                 size_t piecewise_point_count);
    stp_curve_t* stp_read_and_compose_curves(char* s1, char* s2, \
                                             stp_curve_compose_t comp, \
                                             size_t piecewise_point_count)
                                             
    # extern void stp_abort(void);
    void stp_abort()
    
    # extern void stp_prune_inactive_options(stp_vars_t *v);
    void stp_prune_inactive_options(stp_vars_t* v)

    # extern void stp_zprintf(const stp_vars_t *v, const char *format, ...)
    #                         __attribute__((format(__printf__, 2, 3)));
    void stp_zprintf(stp_vars_t* v, char* format, ...)

    # extern void stp_zfwrite(const char *buf, size_t bytes, size_t nitems,
    #                         const stp_vars_t *v);
    void stp_zfwrite(char* buf, size_t bytes, size_t nitems, stp_vars_t* v)
    
    # extern void stp_putc(int ch, const stp_vars_t *v);
    void stp_putc(int ch, stp_vars_t* v)
    
    # extern void stp_put16_le(unsigned short sh, const stp_vars_t *v);
    void stp_put16_le(unsigned short sh, stp_vars_t* v)
     
    # extern void stp_put16_be(unsigned short sh, const stp_vars_t *v);
    void stp_put16_be(unsigned short sh, stp_vars_t* v)
    
    # extern void stp_put32_le(unsigned int sh, const stp_vars_t *v);
    void stp_put32_le(unsigned int sh, stp_vars_t* v)
    
    # extern void stp_put32_be(unsigned int sh, const stp_vars_t *v);
    void stp_put32_be(unsigned int sh, stp_vars_t* v)
    
    # extern void stp_puts(const char *s, const stp_vars_t *v);
    void stp_puts(char* s, stp_vars_t* v)
    
    # extern void stp_putraw(const stp_raw_t *r, const stp_vars_t *v);
    void stp_putraw(stp_raw_t* r, stp_vars_t* v)
    
    # extern void stp_send_command(const stp_vars_t *v, const char *command,
    #                              const char *format, ...);
    void stp_send_command(stp_vars_t* v, char* command, char* format, ...)

    # extern void stp_erputc(int ch);
    void stp_erputc(int ch)

    # extern void stp_eprintf(const stp_vars_t *v, const char *format, ...)
    #   __attribute__((format(__printf__, 2, 3)));
    void stp_eprintf(stp_vars_t* v, char* format, ...)
    
    # extern void stp_erprintf(const char *format, ...)
    #   __attribute__((format(__printf__, 1, 2)));
    void stp_erprintf(char* format, ...)
    
    # extern void stp_asprintf(char **strp, const char *format, ...)
    #   __attribute__((format(__printf__, 2, 3)));
    void stp_asprintf(char** strp, char* format, ...)
    
    # extern void stp_catprintf(char **strp, const char *format, ...)
    #   __attribute__((format(__printf__, 2, 3)));
    void stp_catprintf(char** strp, char* format, ...)
    
    
    # extern unsigned long stp_get_debug_level(void);
    int stp_get_debug_level()
    
    # extern void stp_dprintf(unsigned long level, const stp_vars_t *v,
    #      const char *format, ...)
    #   __attribute__((format(__printf__, 3, 4)));
    void stp_dprintf(unsigned long level, stp_vars_t *v, char *format, ...)
    
    # extern void stp_deprintf(unsigned long level, const char *format, ...)
    #    __attribute__((format(__printf__, 2, 3)));
    void stp_deprintf(unsigned long level, char *format, ...)
    
    # extern void stp_init_debug_messages(stp_vars_t *v);
    void stp_init_debug_messages(stp_vars_t* v)
    
    # extern void stp_flush_debug_messages(stp_vars_t *v);
    void stp_flush_debug_messages(stp_vars_t* v)



    # extern void *stp_malloc (size_t);
    void* stp_malloc (size_t)
    
    # extern void *stp_zalloc (size_t);
    void* stp_zalloc (size_t)
    
    # extern void *stp_realloc (void *ptr, size_t);
    void* stp_realloc (void* ptr, size_t)
    
    # extern void stp_free(void *ptr);
    void stp_free(void* ptr)


    

    # extern size_t stp_strlen(const char *s);
    size_t stp_strlen(char* s)
    
    # extern char *stp_strndup(const char *s, int n);
    char* stp_strndup(char* s, int n)
    
    # extern char *stp_strdup(const char *s);
    char* stp_strdup(char* s)

    # extern const char *stp_get_version(void);
    char* stp_get_version()

    # extern const char *stp_get_release_version(void);
    char* stp_get_release_version()




