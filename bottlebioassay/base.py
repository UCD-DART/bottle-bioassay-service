from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Table, Column, Integer,\
                       String, DateTime, Text, Numeric, MetaData, ForeignKey

Base = declarative_base(metadata=MetaData(schema='resistance'))


class BottleTest(Base):
    __tablename__ = 'bottle_test'

    id = Column(Integer, primary_key=True)
    name = Column(String)
    test_by = Column(String)
    login_id = Column(Integer)
    agency_id = Column(Integer)
    test_date = Column(DateTime)
    description = Column(Text)
    control_mortality = Column(Numeric)
    material_id = Column(Integer)
    lot = Column(String)
    diagnostic_dose = Column(String)
    synergist_id = Column(Integer)
    synergist_lot = Column(String)
    synergist_dose = Column(String)
    add_date = Column(DateTime)
    delete_date = Column(DateTime)


class BottleGroup(Base):
    __tablename__ = 'bottle_test_group'

    id = Column(Integer, primary_key=True)
    bottle_test = Column(
        'bottle_test_id', Integer, ForeignKey('BottleTest.id')
    )
    login_id = Column(Integer)
    agency_id = Column(Integer)
    bio_class_id = Column(Integer)
    mosquitoes_source = Column(String)
    name = Column(String)
    generation = Column(Integer)
    add_date = Column(DateTime)
    delete_date = Column(DateTime)


class Bottle(Base):
    __tablename__ = 'bottle_test_group_member'

    id = Column(Integer, primary_key=True)
    bottle_test_group = Column(
        'bottle_test_group_id', Integer, ForeignKey('BottleTestGroup.id')
    )
    login_id = Column(Integer)
    agency_id = Column(Integer)
    num_tested = Column(Integer)
    replicate_num = Column(Integer)
    add_date = Column(DateTime)
    delete_date = Column(DateTime)


class BottleResult(Base):
    __tablename__ = 'bottle_test_group_member_result'

    id = Column(Integer, primary_key=True)
    bottle = Column(
        'bottle_test_group_member_id', 
        Integer, 
        ForeignKey('BottleTestGroupMember.id')
    )
    time = Column('exposure_length', Integer)
    alive = Column('survival_count', Integer)