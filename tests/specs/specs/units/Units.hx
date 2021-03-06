package specs.units;

import utest.*;
import utest.ui.common.*;
import ecso.Entity;
import specs.systems.*;

class Units extends buddy.SingleSuite {

    var entities:EntityGroup;
    
    public function new () {

        describe('Process optional components', {
            
            beforeEach({
                entities = new EntityGroup();
                entities.createEntity({
                    x: 4,
                    y: 4
                });
            });

            it('with anonymous functions', {
                var count = 0;
                entities.foreachEntity((e:{ x:Int, ?z:Int }) -> {
                    Assert.isNull(e.z);
                    e.z = 5;
                    count++;
                });
                entities.foreachEntity((e:{ z:Int }) -> {
                    Assert.equals(5, e.z);
                    count++;
                });
                Assert.equals(2, count);
            });

            it('with local functions', {
                var count = 0;
                function pre (e:{ x:Int, ?z:Int }) {
                    Assert.isNull(e.z);
                    e.z = 5;
                    count++;
                }
                function post (e:{ z:Int }) {
                    Assert.equals(5, e.z);
                    count++;
                }
                entities.foreachEntity(pre);
                entities.foreachEntity(post);
                Assert.equals(2, count);
            });

            it('with member functions', {
                fieldCount = 0;
                entities.foreachEntity(fieldPre);
                entities.foreachEntity(fieldPost);
                Assert.equals(2, fieldCount);
            });

            it('with static functions', {
                staticCount = 0;
                entities.foreachEntity(staticPre);
                entities.foreachEntity(staticPost);
                Assert.equals(2, staticCount);
            });

            it('with null safety', {
                nullSafety();
            });
        });
    }

    @:nullSafety(Strict) function nullSafety () {
        staticCount = 0;
        entities.foreachEntity(staticPre);
        entities.foreachEntity(staticPost);
        Assert.equals(2, staticCount);
    }

    // members

    var fieldCount:Int;
    function fieldPre (e:{ x:Int, ?z:Int }) {
        Assert.isNull(e.z);
        e.z = 5;
        fieldCount++;
    }
    function fieldPost (e:{ z:Int }) {
        Assert.equals(5, e.z);
        fieldCount++;
    }

    // statics

    static var staticCount:Int;
    static function staticPre (e:{ x:Int, ?z:Int }) {
        Assert.isNull(e.z);
        e.z = 5;
        staticCount++;
    }
    static function staticPost (e:{ z:Int }) {
        Assert.equals(5, e.z);
        staticCount++;
    }
}