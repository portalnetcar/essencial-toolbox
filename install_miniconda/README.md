## Miniconda

### How the best option? Conda or Miniconda?

Both [Conda](https://docs.conda.io/projects/conda/en/latest/) and [Miniconda](https://docs.conda.io/en/latest/miniconda.html) are popular tools for managing Python packages and dependencies in a cross-platform way, but they have different use cases:

**Conda (Full Anaconda Distribution):**
- Conda is an open-source package management system that runs on Windows, macOS, and Linux. It's built to handle software that is installed for the purpose of using Python packages like scikit-learn or Numpy. 
- It has a larger number of channels compared to Miniconda. The Anaconda repository as well as several third-party repositories are available by default, which means it can provide more options when installing packages.
- However, Conda is slower due to the large number of channels and packages that have to be downloaded during installation or update operations. 

**Miniconda (Minimal Anaconda Distribution):**
- Miniconda includes only conda, Python, and a small number of other essential packages like `pip` and `perl`. It's much smaller in size than the full Anaconda distribution and can be installed quickly. 
- It is best suited for users who want to manage their own environments and do not need all the extra features that come with the larger Anaconda suite, such as R and Jupyter notebook kernels.
- Miniconda also has fewer channels compared to full Conda which can be a benefit if you want to limit package updates or control versions for security reasons. 

So, whether you should use Conda or Miniconda depends on your specific needs:
1. If you need the flexibility of managing environments and not tied to any single operating system (like Linux, macOS, Windows), go with full Anaconda distribution.
2. If you want to avoid downloading thousands of packages during installations/updates and are okay with less options, then Miniconda is a good choice. 
3. If speed and simplicity are your priorities, stick with Miniconda.
