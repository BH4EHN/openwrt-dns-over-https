include $(TOPDIR)/rules.mk

PKG_NAME:=dns-over-https
PKG_VERSION:=2.2.5
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_SOURCE_URL:=https://github.com/m13253/dns-over-https/archive/refs/tags/v${PKG_VERSION}.tar.gz
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SHA1SUM=387a2481135a7e131c20967b842d45a2a578893a

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=BH4EHN <edyuy@zmyseries.com>

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=https://github.com/m13253/dns-over-https
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:=main.VERSION=v$(PKG_VERSION)
# PKG_CONFIG_DEPENDS:= 

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/$(PKG_NAME)
  TITLE:=DNS-over-HTTPS
  URL:=https://github.com/m13253/dns-over-https
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/$(PKG_NAME)/description
	Client and server software to query DNS over HTTPS, using Google DNS-over-HTTPS protocol and IETF DNS-over-HTTPS (RFC 8484).
endef

define Build/Prepare
	$(call Build/Prepare/Default)
endef

define Build/Compile
	$(call GoPackage/Build/Compile)
	# comment this line if upx not present
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/doh-client
	chmod +x ./files/etc/init.d/dns-over-https
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/doh-client $(1)/usr/bin/doh-client
endef

$(eval $(call GoBinPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
