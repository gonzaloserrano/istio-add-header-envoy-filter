FROM scratch

COPY add-header-filter-static /usr/local/bin/add-header-filter-static

ENTRYPOINT [ "/usr/local/bin/add-header-filter-static" ]
