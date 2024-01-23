from setuptools import setup, find_packages

setup(
    name='diffusion_face_anonymisation',
    author='Marvin Klemp, Kevin Rösch, Royden Wagner',
    author_email='marvin.klemp@kit.edu, kevin.roesch@fzi.de, royden.wagner@kit.edu',
    version='1.0.0',
    packages=find_packages(where='src'),
    package_dir={'': 'src'},
)