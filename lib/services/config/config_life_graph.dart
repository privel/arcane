class ConfigLifeGraph {
  bool isMobile;
  bool isTablet;

  ConfigLifeGraph(this.isMobile, this.isTablet);

  double get sizeContainerGraph {
    if (isMobile) return 550;
    if (isTablet) return 870;
    return 780;
  }

  int get columnOrderResponsiveGraph {
    if (isMobile || isTablet) return 1;
    return 0;
  }

  int get columnOrderResponsiveDate {
    if (isMobile || isTablet) return 0;
    return 1;
  }
}
