<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addSportItem') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="sportItemTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('eventId')" prop="event_id">
                        <el-input v-model="sportItemTable.searchParam.event_id" :placeholder="t('eventIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('baseItemId')" prop="base_item_id">
                        <el-input v-model="sportItemTable.searchParam.base_item_id" :placeholder="t('baseItemIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('categoryId')" prop="category_id">
                        <el-input v-model="sportItemTable.searchParam.category_id" :placeholder="t('categoryIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="sportItemTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('competitionType')" prop="competition_type">
                        <el-input v-model="sportItemTable.searchParam.competition_type" :placeholder="t('competitionTypePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('genderType')" prop="gender_type">
                        <el-input v-model="sportItemTable.searchParam.gender_type" :placeholder="t('genderTypePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('ageGroup')" prop="age_group">
                        <el-input v-model="sportItemTable.searchParam.age_group" :placeholder="t('ageGroupPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('maxParticipants')" prop="max_participants">
                        <el-input v-model="sportItemTable.searchParam.max_participants" :placeholder="t('maxParticipantsPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('minParticipants')" prop="min_participants">
                        <el-input v-model="sportItemTable.searchParam.min_participants" :placeholder="t('minParticipantsPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('registrationFee')" prop="registration_fee">
                        <el-input v-model="sportItemTable.searchParam.registration_fee" :placeholder="t('registrationFeePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('rules')" prop="rules">
                        <el-input v-model="sportItemTable.searchParam.rules" :placeholder="t('rulesPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('equipment')" prop="equipment">
                        <el-input v-model="sportItemTable.searchParam.equipment" :placeholder="t('equipmentPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('venueRequirements')" prop="venue_requirements">
                        <el-input v-model="sportItemTable.searchParam.venue_requirements" :placeholder="t('venueRequirementsPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('refereeRequirements')" prop="referee_requirements">
                        <el-input v-model="sportItemTable.searchParam.referee_requirements" :placeholder="t('refereeRequirementsPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('sort')" prop="sort">
                        <el-input v-model="sportItemTable.searchParam.sort" :placeholder="t('sortPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="sportItemTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option
                                v-for="(item, index) in statusList"
                                :key="index"
                                :label="item.name"
                                :value="item.value"
                            />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('remark')" prop="remark">
                        <el-input v-model="sportItemTable.searchParam.remark" :placeholder="t('remarkPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-input v-model="sportItemTable.searchParam.create_time" :placeholder="t('createTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-input v-model="sportItemTable.searchParam.update_time" :placeholder="t('updateTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadSportItemList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="sportItemTable.data" size="large" v-loading="sportItemTable.loading">
                    <template #empty>
                        <span>{{ !sportItemTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="event_id" :label="t('eventId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="base_item_id" :label="t('baseItemId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="category_id" :label="t('categoryId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="competition_type" :label="t('competitionType')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="gender_type" :label="t('genderType')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="age_group" :label="t('ageGroup')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="max_participants" :label="t('maxParticipants')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="min_participants" :label="t('minParticipants')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="registration_fee" :label="t('registrationFee')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="rules" :label="t('rules')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="equipment" :label="t('equipment')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="venue_requirements" :label="t('venueRequirements')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="referee_requirements" :label="t('refereeRequirements')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <div v-if="item.value == row.status">{{ item.name }}</div>
                            </div>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="remark" :label="t('remark')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="sportItemTable.page" v-model:page-size="sportItemTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="sportItemTable.total"
                        @size-change="loadSportItemList()" @current-change="loadSportItemList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getSportItemList, deleteSportItem } from '@/addon/sport/api/sport_item'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let sportItemTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "event_id":"",
      "base_item_id":"",
      "category_id":"",
      "name":"",
      "competition_type":"",
      "gender_type":"",
      "age_group":"",
      "max_participants":"",
      "min_participants":"",
      "registration_fee":"",
      "rules":"",
      "equipment":"",
      "venue_requirements":"",
      "referee_requirements":"",
      "sort":"",
      "status":"",
      "remark":"",
      "create_time":"",
      "update_time":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    const statusList = ref([] as any[])
    const statusDictList = async () => {
    statusList.value = await (await useDictionary('status')).data.dictionary
    }
    statusDictList();

/**
 * 获取比赛项目列表
 */
const loadSportItemList = (page: number = 1) => {
    sportItemTable.loading = true
    sportItemTable.page = page

    getSportItemList({
        page: sportItemTable.page,
        limit: sportItemTable.limit,
         ...sportItemTable.searchParam
    }).then(res => {
        sportItemTable.loading = false
        sportItemTable.data = res.data.data
        sportItemTable.total = res.data.total
    }).catch(() => {
        sportItemTable.loading = false
    })
}
loadSportItemList()

const router = useRouter()

/**
 * 添加比赛项目
 */
const addEvent = () => {
    router.push('/sport_item/sport_item_edit')
}

/**
 * 编辑比赛项目
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/sport_item/sport_item_edit?id='+data.id)
}

/**
 * 删除比赛项目
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('sportItemDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteSportItem(id).then(() => {
            loadSportItemList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadSportItemList()
}
</script>

<style lang="scss" scoped>
/* 多行超出隐藏 */
.multi-hidden {
		word-break: break-all;
		text-overflow: ellipsis;
		overflow: hidden;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
	}
</style>
