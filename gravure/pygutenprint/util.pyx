# -*- coding: utf-8 -*-

# $Id: $
# util.pyx
# Cython module pygutenprint.util
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
"""Module pygutenprint.util.

Utility functions.
"""

__author__ = "Gilles Coissac <gilles@atelierobscur.org>"
__date__ = "4 May 2010"
__version__ = "$Revision: 0.1 $"
__credits__ = "Atelier Obscur : www.atelierobscur.org"



def init():
    """Initialise libgimpprint.
    
    This function must be called prior to any other use of the library.   
    It is responsible for loading modules and XML data and initialising
    internal data structures.
    
    Returns: - True on success
             - False on failure
    """
    retcode = stp_init()
    if (retcode): print "stp_init failure"
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


def get_version():
    """Get the library version string (x.y.z).
    
    Returns: A Python string of the version name of the package.
    """
    return <char*> stp_get_version()


def get_release_version():
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

    
    
