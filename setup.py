from setuptools import setup, find_packages


setup(
    name='articular',
    version='0.1.0',
    description='Create knowledge graphs from Markdown documents.',
    url='https://github.com/edwardanderson/articular',
    author='Edward Anderson',
    license='MIT',
    keywords=[
        'Markdown',
        'JSON-LD',
        'Linked Data',
        'Linked Open Data',
        'Knowledge Graph'
    ],
    packages=find_packages(),
    install_requires=[
        'lxml',
        'pypandoc',
        'python-frontmatter',
        'requests',
        'rdflib',
        'rich',
        'xmltodict'
    ],
    entry_points = {
        'console_scripts': [
            'articular=articular.cli:main'
        ]
    },
    include_package_data=True,
    zip_safe=False
)
