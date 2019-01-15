import db
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Table, Column, Integer,\
                       String, DateTime, Text, Numeric, MetaData, ForeignKey

__all__ = ['BottleTest', 'Bottle', 'BottleCount', 'Base']

Base = declarative_base(metadata=MetaData(schema='resistance'))


class BottleTest(Base):
    __tablename__ = 'test_group'

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


class Bottle(Base):
    __tablename__ = 'test_group_member'

    id = Column(Integer, primary_key=True)
    bottle_test = Column('test_group_id', Integer, ForeignKey('test_group.id'))
    comments = Column(Text)
    login_id = Column(Integer)
    agency_id = Column(Integer)
    num_tested = Column(Integer)
    replicate_num = Column(Integer)
    bio_class_id = Column(Integer)
    mosquitoes_source = Column(String)
    colony_name = Column(String)
    generation = Column(Integer)
    add_date = Column(DateTime)
    delete_date = Column(DateTime)


class BottleCount(Base):
    __tablename__ = 'test_group_result'

    id = Column(Integer, primary_key=True)
    bottle = Column('test_group_member_id',
                    Integer,
                    ForeignKey('test_group_member.id'))
    exposure_length = Column(Integer)
    survival_count = Column(Integer)
