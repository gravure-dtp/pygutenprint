# -*- coding: utf-8 -*-

# Copyright (C) 2011 Atelier Obscur.
# Authors:
# Gilles Coissac <dev@atelierobscur.org>

# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License with
# the Debian GNU/Linux distribution in file /usr/share/common-licenses/GPL;
# if not, write to the Free Software Foundation, Inc., 51 Franklin St,
# Fifth Floor, Boston, MA 02110-1301, USA.

"""Module pygutenprint.util.

Utility functions.
"""

#include <gutenprint/curve.h>
#include <gutenprint/vars.h>

cdef extern from "gutenprint/util.h":
    # Debug macros constant
    cdef enum:
        STP_DBG_LUT
        STP_DBG_COLORFUNC
        STP_DBG_INK
        STP_DBG_PS
        STP_DBG_PCL
        STP_DBG_ESCP2
        STP_DBG_CANON
        STP_DBG_LEXMARK
        STP_DBG_WEAVE_PARAMS
        STP_DBG_ROWS
        STP_DBG_MARK_FILE
        STP_DBG_LIST
        STP_DBG_MODULE
        STP_DBG_PATH
        STP_DBG_PAPER
        STP_DBG_PRINTERS
        STP_DBG_XML
        STP_DBG_VARS
        STP_DBG_DYESUB
        STP_DBG_CURVE
        STP_DBG_CURVE_ERRORS
        STP_DBG_PPD
        STP_DBG_NO_COMPRESSION
        STP_DBG_ASSERTIONS

    # extern int stp_init(void);
    bint stp_init()

    # extern const char *stp_set_output_codeset(const char *codeset);
    char* stp_set_output_codeset(char* codeset)

    # extern stp_curve_t *stp_read_and_compose_curves(const char *s1, const char *s2,
    #                                                 stp_curve_compose_t comp,
    #                                                 size_t piecewise_point_count);
    #stp_curve_t* stp_read_and_compose_curves(char* s1, char* s2, \
    #                                         stp_curve_compose_t comp, \
    #                                         size_t piecewise_point_count)

    # extern void stp_abort(void);
    void stp_abort()

    # extern void stp_prune_inactive_options(stp_vars_t *v);
    #void stp_prune_inactive_options(stp_vars_t* v)

    # extern void stp_zprintf(const stp_vars_t *v, const char *format, ...)
    #                         __attribute__((format(__printf__, 2, 3)));
    #void stp_zprintf(stp_vars_t* v, char* format, ...)

    # extern void stp_zfwrite(const char *buf, size_t bytes, size_t nitems,
    #                         const stp_vars_t *v);
    #void stp_zfwrite(char* buf, size_t bytes, size_t nitems, stp_vars_t* v)

    #extern void stp_write_raw(const stp_raw_t *raw, const stp_vars_t *v);

    # extern void stp_putc(int ch, const stp_vars_t *v);
    #void stp_putc(int ch, stp_vars_t* v)

    # extern void stp_put16_le(unsigned short sh, const stp_vars_t *v);
    #void stp_put16_le(unsigned short sh, stp_vars_t* v)

    # extern void stp_put16_be(unsigned short sh, const stp_vars_t *v);
    #void stp_put16_be(unsigned short sh, stp_vars_t* v)

    # extern void stp_put32_le(unsigned int sh, const stp_vars_t *v);
    #void stp_put32_le(unsigned int sh, stp_vars_t* v)

    # extern void stp_put32_be(unsigned int sh, const stp_vars_t *v);
    #void stp_put32_be(unsigned int sh, stp_vars_t* v)

    # extern void stp_puts(const char *s, const stp_vars_t *v);
    #void stp_puts(char* s, stp_vars_t* v)

    # extern void stp_putraw(const stp_raw_t *r, const stp_vars_t *v);
    #void stp_putraw(stp_raw_t* r, stp_vars_t* v)

    # extern void stp_send_command(const stp_vars_t *v, const char *command,
    #                              const char *format, ...);
    #void stp_send_command(stp_vars_t* v, char* command, char* format, ...)

    # extern void stp_erputc(int ch);
    void stp_erputc(int ch)

    # extern void stp_eprintf(const stp_vars_t *v, const char *format, ...)
    #   __attribute__((format(__printf__, 2, 3)));
    #void stp_eprintf(stp_vars_t* v, char* format, ...)

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
    #void stp_dprintf(unsigned long level, stp_vars_t *v, char *format, ...)

    # extern void stp_deprintf(unsigned long level, const char *format, ...)
    #    __attribute__((format(__printf__, 2, 3)));
    void stp_deprintf(unsigned long level, char *format, ...)

    # extern void stp_init_debug_messages(stp_vars_t *v);
    #void stp_init_debug_messages(stp_vars_t* v)

    # extern void stp_flush_debug_messages(stp_vars_t *v);
    #void stp_flush_debug_messages(stp_vars_t* v)

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


cpdef bint init():
    """Initialise libgimpprint.

    This function must be called prior to any other use of the library.
    It is responsible for loading modules and XML data and initialising
    internal data structures.

    Returns: - True on success
             - False on failure
    """
    cdef bint retcode
    retcode = stp_init()
    if (retcode):
        print("stp_init failure")
    return not retcode


def set_output_codeset():
    """NOT YET IMPLEMENTED ! Set the output encoding.

    This function sets the encoding that all
    strings translated by gettext are output in.
    It is a wrapper around the gettext bind_textdomain_codeset() function.

    Param: - codeset the standard name of the encoding, which must be
             usable with iconv_open().  For example, "US-ASCII" or "UTF-8".
             If NULL, the currently-selected codeset will be returned
             (or NULL if no codeset has been selected yet).

    Returns: A string containing the selected codeset, or NULL on
             failure (errno is set accordingly).
    """
    raise NotImplementedError


def read_and_compose_curves():
    """NOT YET IMPLEMENTED ! read_and_compose_curves
    """
    raise NotImplementedError


def abort():
    """NOT YET IMPLEMENTED ! stp_abort
    """
    raise NotImplementedError


def prune_inactive_options():
    """NOT YET IMPLEMENTED ! Remove inactive and unclaimed options from the list.
    """
    raise NotImplementedError


def zprintf():
    """NOT YET IMPLEMENTED ! zprintf.
    """
    raise NotImplementedError


def zfwrite():
    """NOT YET IMPLEMENTED ! zfwrite.
    """
    raise NotImplementedError


def putc():
    """NOT YET IMPLEMENTED ! putc.
    """
    raise NotImplementedError


def put16_le():
    """NOT YET IMPLEMENTED ! put16_le.
    """
    raise NotImplementedError


def put16_be():
    """NOT YET IMPLEMENTED ! put16_be.
    """
    raise NotImplementedError


def put32_le():
    """NOT YET IMPLEMENTED ! put32_le.
    """
    raise NotImplementedError


def put32_be():
    """NOT YET IMPLEMENTED ! put32_be.
    """
    raise NotImplementedError


def puts():
    """NOT YET IMPLEMENTED ! puts.
    """
    raise NotImplementedError


def putraw():
    """NOT YET IMPLEMENTED ! putraw.
    """
    raise NotImplementedError


def send_command():
    """NOT YET IMPLEMENTED ! send_command.
    """
    raise NotImplementedError


def erputc():
    """NOT YET IMPLEMENTED ! erputc.
    """
    raise NotImplementedError


def eprintf():
    """NOT YET IMPLEMENTED ! eprintf.
    """
    raise NotImplementedError

def erprintf():
    """NOT YET IMPLEMENTED ! erprintf.
    """
    raise NotImplementedError


def asprintf():
    """NOT YET IMPLEMENTED ! asprintf.
    """
    raise NotImplementedError


def catprintf():
    """NOT YET IMPLEMENTED ! catprintf.
    """
    raise NotImplementedError


def get_debug_level():
    """NOT YET IMPLEMENTED ! get_debug_level.
    """
    raise NotImplementedError


def dprintf():
    """NOT YET IMPLEMENTED ! dprintf.
    """
    raise NotImplementedError


def deprintf():
    """NOT YET IMPLEMENTED ! deprintf.
    """
    raise NotImplementedError


def init_debug_messages():
    """NOT YET IMPLEMENTED ! init_debug_messages.
    """
    raise NotImplementedError


def flush_debug_messages():
    """NOT YET IMPLEMENTED ! flush_debug_messages.
    """
    raise NotImplementedError


## extern void *stp_malloc (size_t);
#void* stp_malloc (size_t)
#
## extern void *stp_zalloc (size_t);
#void* stp_zalloc (size_t)
#
## extern void *stp_realloc (void *ptr, size_t);
#void* stp_realloc (void* ptr, size_t)
#
## extern void stp_free(void *ptr);
#void stp_free(void* ptr)


## extern size_t stp_strlen(const char *s);
#size_t stp_strlen(char* s)
#
## extern char *stp_strndup(const char *s, int n);
#char* stp_strndup(char* s, int n)
#
## extern char *stp_strdup(const char *s);
#char* stp_strdup(char* s)


cpdef char* get_version():
    """Get the library version string (x.y.z).

    Returns: A Python string of the version name of the package.
    """
    return <char*> stp_get_version()


cpdef char* get_release_version():
    """Get the library release version string (x.y).

    Returns: A Python string of the release name of the package.
    """
    return <char*> stp_get_release_version()


#define STP_SAFE_FREE(x)            \
#    do                        \
#    {                        \
#      if ((x))                    \
#        stp_free((char *)(x));            \
#      ((x)) = NULL;                    \
#    } while (0)

#cdef void STP_SAFE_FREE(int x):
#    do:
#        if ((x)):
#            stp_free(<char *>(x))
#        ((x)) = NULL
#    while (0)



