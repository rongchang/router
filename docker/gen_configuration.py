#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = 'arkii'
__email__ = 'sunqy@edaixi.com'
__create__ = '2016.05.26 22:42'
__project__ = ''

import os
import sys
import yaml
import re
import io
from jinja2 import Environment, FileSystemLoader

# CONF = os.path.join(os.path.curdir, 'config.yml')


def env_os(value, key):
    ''' usage:
        {{"default" | env_os('CUSTOM')}} '''
    return os.getenv(key, default=value)

JENV = Environment(loader=FileSystemLoader(os.path.curdir, encoding='utf-8'))
JENV.filters['env_os'] = env_os


def prepare(path):
    try:
        os.makedirs(path)
    except OSError:
        print('folder exists')


def renderFile(filename):
    tpl = JENV.get_template(filename)
    env = os.environ
    return tpl.render(env=env)


def saveFile(contents, filename):
    try:
        with io.open(filename, 'w+', encoding='utf8') as fh:
            # with open(filename, 'w+') as fh:
            fh.write(contents)
    except IOError('file can not save') as e:
        print(e)


# def loadConf(filename):
#     try:
#         with open(filename, 'r') as fh:
#             return yaml.safe_load(fh)
#     except IOError('file can not load') as e:
#         raise e


def genSrcDstPath(src, dst):
    '''  '''
    # print(src, dst)
    f_filter = r'^\.'
    for subdir, dirs, files in os.walk(src, topdown=True,
                                       onerror=None, followlinks=False):
        abspath = os.path.abspath(subdir)
        t_files = []
        for i in files:
            if not re.search(f_filter, i):
                t_files.append(i)
        for f in t_files:
            relpath = os.path.join(subdir, f).replace(src, '')
            relpath = re.sub(r'^/+', '', relpath)
            yield (os.path.join(subdir, f), os.path.join(dst, relpath))


def main():
    usage = ''' Usage:
    cd docker
    {filename} tpl/apps /app/apps
    {filename} tpl/nginx.conf nginx/app.conf
    {filename} /app/docker/configs /app/apps/configs
    {filename} /app/docker/configs/db.php /app/apps/config/db.php
    first arg is template folder or file, the second arg is target path that
    configs will be saved.
    '''

    if len(sys.argv) != 3:  # check args number, must be 2
        print(usage.format(filename=sys.argv[0]))
        exit(1)
    else:
        src = sys.argv[1]
        dst = sys.argv[2]
        # if ('docker' in src) and (os.path.exists(src)):  # check src path
        if os.path.exists(src):  # check src path
            if os.path.isdir(src):  # 源是目录
                for s_file, d_file in genSrcDstPath(src, dst):
                    print(s_file, d_file)  # for debug
                    d_dir = os.path.dirname(d_file)
                    prepare(path=d_dir)
                    contents = renderFile(s_file)
                    # u = contents.decode('utf-8')
                    saveFile(contents=contents, filename=d_file)
            elif os.path.isfile(src):  # 源是文件
                filename = os.path.basename(dst)
                pathname = os.path.dirname(dst)
                prepare(path=pathname)
                contents = renderFile(src)
                saveFile(contents=contents, filename=dst)
            else:
                print(usage.format(filename=sys.argv[0]))
                exit(1)
        else:
            print(usage.format(filename=sys.argv[0]))
            exit(1)

if __name__ == '__main__':
    main()
