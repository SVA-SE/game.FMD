# Determine package name and version from DESCRIPTION file
PKG_VERSION=$(shell grep -i ^version DESCRIPTION | cut -d : -d \  -f 2)
PKG_NAME=$(shell grep -i ^package DESCRIPTION | cut -d : -d \  -f 2)

# Name of built package
PKG_TAR=$(PKG_NAME)_$(PKG_VERSION).tar.gz

# Install package
.PHONY: install
install:
	cd .. && R CMD INSTALL $(PKG_NAME)

# Build documentation with roxygen (first delete previous roxygen files)
.PHONY: roxygen
roxygen:
	Rscript -e "roxygen2::roxygenize(clean = TRUE)"

# Build package
.PHONY: build
build:
	cd .. && R CMD build --compact-vignettes=both $(PKG_NAME)

# Check package
.PHONY: check
check: build
	cd .. && OMP_THREAD_LIMIT=2 _R_CHECK_CRAN_INCOMING_=FALSE R CMD check \
        --no-stop-on-test-error --as-cran --run-dontrun $(PKG_TAR)