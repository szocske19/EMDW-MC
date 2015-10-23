##############################################################################
# [M O D E L / C O M P O N E N T / P A C K A G E]   M A K E   R U L E S
#
# NAME: Collections
#
# Generated by EMDW-MC
#
##############################################################################

sp				:= $(sp).x
dirstack_$(sp)	:= $(d)
d				:= $(dir)

dir := 	$(d)/bag
include $(dir)/Rules.mk

dir := 	$(d)/deque
include $(dir)/Rules.mk

dir := 	$(d)/list
include $(dir)/Rules.mk

dir := 	$(d)/sequence
include $(dir)/Rules.mk

dir := 	$(d)/set
include $(dir)/Rules.mk


SOURCES_$(d)	:= $(wildcard $(d)/*.cc)
OBJECTS_$(d)	:= $(SOURCES_$(d):%.cc=%.o)

SOURCES	:= $(SOURCES) $(SOURCES_$(d))
OBJECTS	:= $(OBJECTS) $(OBJECTS_$(d))

d	:= $(dirstack_$(sp))
sp	:= $(basename $(sp))